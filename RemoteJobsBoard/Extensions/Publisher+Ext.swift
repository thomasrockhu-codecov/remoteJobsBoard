import Combine
import Foundation

public extension Publisher {

    /// Attaches a subscriber with closure-based behavior.
    /// - Parameter receiveValue: The closure to execute on completion.
    func sink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: receiveValue)
    }

    /// Attaches a subscriber with closure-based behavior.
    /// - Parameter receiveCompletion: The closure to execute on completion.
    /// - Returns: A subscriber that performs the provided closures upon receiving values or completion.
    func sink(receiveCompletion: @escaping ((Subscribers.Completion<Failure>) -> Void)) -> AnyCancellable {
        // swiftlint:disable:next trailing_closure
        sink(receiveCompletion: receiveCompletion, receiveValue: { _ in })
    }

    func sink(receiveFailure: @escaping (Failure) -> Void) -> AnyCancellable {
        // swiftlint:disable:next trailing_closure
        sink(receiveCompletion: {
            switch $0 {
            case .failure(let error):
                receiveFailure(error)
            case .finished:
                break
            }
        })
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
