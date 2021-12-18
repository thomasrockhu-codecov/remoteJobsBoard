import Combine
import Foundation

final class APIService {

	// MARK: - Typealiases

	fileprivate typealias Output = URLSession.DataTaskPublisher.Output
	fileprivate typealias DataTaskPublisher = AnyPublisher<Output, ServiceError>

	// MARK: - Properties

	private let requestQueue = DispatchQueue(label: "APIReqiestQueue", qos: .userInitiated)

	private let session = makeSession()
	private var urlCache: URLCache? { session.configuration.urlCache }

}

// MARK: - Private Methods

private extension APIService {

	static func makeSession() -> URLSession {
		let configuration = URLSessionConfiguration.default

		let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
			.first?
			.appendingPathComponent(Constant.responsesCachePath)
		configuration.urlCache = URLCache(
			memoryCapacity: Constant.capacity,
			diskCapacity: Constant.capacity,
			directory: directory
		)

		return URLSession(configuration: configuration)
	}

	static func decode<Model: Decodable>(type: Model.Type, from data: Data) throws -> Model {
		do {
			return try JSONDecoder().decode(Model.self, from: data)
		} catch {
			throw ServiceError.decoding(model: Model.self, error: error)
		}
	}

	static func validate(output: Output) throws -> Output {
		switch (output.response as? HTTPURLResponse)?.statusCode {
		case 200:
			return output
		case 429:
			throw ServiceError.tooManyRequests
		default:
			throw ServiceError.badServerResponse
		}
	}

	func cachedResponse(for request: URLRequest, maxAge: TimeInterval? = nil) -> CachedURLResponse? {
		guard let cachedResponse = urlCache?.cachedResponse(for: request) else { return nil }

		if let maxAge = maxAge {
			let currentDate = Date()
			guard
				let date = cachedResponse.userInfo?[Constant.cacheDateKey] as? Date,
				date.distance(to: currentDate) > 0,
				date.distance(to: currentDate) < maxAge
			else {
				return nil
			}
			return cachedResponse
		} else {
			return cachedResponse
		}
	}

	func cache(output: Output, for request: URLRequest) {
		let cachedResponse = CachedURLResponse(
			response: output.response,
			data: output.data,
			userInfo: [Constant.cacheDateKey: Date()],
			storagePolicy: .allowed
		)
		urlCache?.storeCachedResponse(cachedResponse, for: request)
	}

	func dataTaskPublisher(forRequestTo path: String) -> AnyPublisher<Data, ServiceError> {
		guard let baseURL = URL(string: Constant.baseURL) else {
			return Fail(error: ServiceError.badBaseURL(Constant.baseURL))
				.eraseToAnyPublisher()
		}
		let request = URLRequest(url: baseURL.appendingPathComponent("remote-jobs"))

		if let cachedResponse = cachedResponse(for: request, maxAge: Constant.cacheMaxAge) {
			return Just(cachedResponse.data)
				.setFailureType(to: ServiceError.self)
				.eraseToAnyPublisher()
		}

		return session.dataTaskPublisher(for: request)
			.subscribe(on: requestQueue)
			.tryMap { try Self.validate(output: $0) }
			.tryCatch { [weak self] error -> DataTaskPublisher in
				guard let cachedResponse = self?.cachedResponse(for: request) else {
					throw error
				}
				return Just((cachedResponse.data, cachedResponse.response))
					.setFailureType(to: ServiceError.self)
					.eraseToAnyPublisher()
			}
			.mapError { ServiceError(error: $0) }
			.handleOutput { [weak self] in self?.cache(output: $0, for: request) }
			.map { $0.data }
			.eraseToAnyPublisher()
	}

}

// MARK: - APIServiceType

extension APIService: APIServiceType {

	func getJobs() -> JobsPublisher {
		dataTaskPublisher(forRequestTo: "remote-jobs")
			.tryMap { try Self.decode(type: JobsResponseModel.self, from: $0) }
			.map { $0.jobs.map { Job(apiModel: $0) } }
			.eraseToAnyPublisher()
	}

}

// MARK: - Constants

private extension APIService {

	enum Constant {

		static let responsesCachePath = "Responses"
		static let cacheDateKey = "cache-date"
		static let baseURL = "https://remotive.io/api"

		/// `14400` seconds (or `4` hours).
		static let cacheMaxAge: TimeInterval = 14_400

		/// 100 MB.
		static let capacity = 104_857_600

	}

}
