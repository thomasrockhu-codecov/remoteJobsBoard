import Foundation

extension APIService {

    enum ServiceError {

        case badServerResponse
        case tooManyRequests
        case badBaseURL(String)
        case urlError(URLError)
        case decoding(model: Any, error: Error)
        case unknownError(Error)

        init(error: Error) {
            switch error {
            case let error as URLError:
                self = .urlError(error)
            case let error as ServiceError:
                self = error
            default:
                self = .unknownError(error)
            }
        }

    }

}

// MARK: - LocalizedError

extension APIService.ServiceError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .badBaseURL(let url):
            return "Bad base URL: \(url)"
        case .badServerResponse:
            return "Bad Server Response"
        case .tooManyRequests:
            return "Too Many Requests"
        case let .decoding(model, error):
            return "Could not decode \(model) from JSON: \(error.localizedDescription)"
        case .urlError(let error):
            return error.localizedDescription
        case .unknownError(let error):
            return error.localizedDescription
        }
    }

}
