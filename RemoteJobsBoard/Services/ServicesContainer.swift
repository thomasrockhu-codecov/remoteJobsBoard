import Foundation

final class ServicesContainer {

    // MARK: - Properties

    let logger: LoggerServiceType

    // MARK: - Initialization

    init(logger: LoggerServiceType) {
        self.logger = logger
    }

}
