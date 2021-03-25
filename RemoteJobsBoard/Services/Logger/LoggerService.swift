import Foundation

final class LoggerService {}

// MARK: - Private Methods

private extension LoggerService {

    /// Calls `print` function if build configuration is set to `DEBUG`.
    ///
    /// - Parameter items: Zero or more items to print.
    func printInDebug(items: Any...) {
        #if DEBUG
        print(items)
        #endif
    }

}

// MARK: - LoggerServiceType

extension LoggerService: LoggerServiceType {

    func log(error: String) {
        assertionFailure(error)
    }

    func log(error: Error) {
        assertionFailure(error.localizedDescription)
    }

    func log(deinitOf object: Any) {
        let describing = String(describing: object)
        printInDebug(items: "\(describing) was deinited")
    }

    func log(items: Any...) {
        printInDebug(items: items)
    }

}
