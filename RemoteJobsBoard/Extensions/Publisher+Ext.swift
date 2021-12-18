import Combine
import Foundation

public extension Publisher {

	/// Performs the specified closures when publisher receives a value from the upstream publisher.
	/// - Parameter handler: A closure that executes when the publisher receives a value from the upstream publisher.
	/// - Returns: A publisher that performs the specified closures when publisher events occur.
	func handleOutput(_ handler: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
		handleEvents(receiveOutput: handler)
	}

	func `catch`(errorHandler: ErrorHandler? = nil) -> AnyPublisher<Output, Never> {
		// swiftlint:disable:next trailing_closure
		map { value -> Output? in value }
		.handleEvents(receiveCompletion: {
			switch $0 {
			case .failure(let error):
				errorHandler?(error)
			case .finished:
				break
			}
		})
		.catch { _ in Just(nil) }
		.compactMap { $0 }
		.eraseToAnyPublisher()
	}

}
