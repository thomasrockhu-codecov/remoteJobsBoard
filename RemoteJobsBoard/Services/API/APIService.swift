import Combine
import Foundation

final class APIService {

    // MARK: - Properties

    private let baseURL = URL(string: "https://remotive.io/api")
    private let requestQueue = DispatchQueue(label: "APIReqiestQueue", qos: .userInitiated)

}

// MARK: - Private Methods

private extension APIService {

    static func decode<Model: Decodable>(type: Model.Type, from data: Data) -> AnyPublisher<Model, ServiceError> {
        Just(data)
            .tryMap { try JSONDecoder().decode(Model.self, from: $0) }
            .mapError { ServiceError.decoding($0) }
            .eraseToAnyPublisher()
    }

    func dataTaskPublisher(forRequestTo path: String) -> AnyPublisher<Data, ServiceError> {
        guard let baseURL = baseURL else {
            return Fail(error: ServiceError.badBaseURL).eraseToAnyPublisher()
        }
        let request = URLRequest(url: baseURL.appendingPathComponent("remote-jobs"))
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: requestQueue)
            .map { $0.data }
            .mapError { ServiceError(error: $0) }
            .eraseToAnyPublisher()
    }
}

// MARK: - APIServiceType

extension APIService: APIServiceType {

    func getJobs() -> JobsPublisher {
        dataTaskPublisher(forRequestTo: "remote-jobs")
            .flatMap { Self.decode(type: JobsResponseModel.self, from: $0) }
            .map { $0.jobs.map { Job(apiModel: $0) } }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }

}

// MARK: - ServiceError

extension APIService {

    enum ServiceError: Error {

        case badBaseURL
        case urlError(URLError)
        case decoding(Error)

        init(error: URLError) {
            self = .urlError(error)
        }

    }

}
