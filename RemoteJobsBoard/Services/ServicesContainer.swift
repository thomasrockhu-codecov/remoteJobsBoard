import Foundation

final class ServicesContainer {

    // MARK: - Properties

    let logger: LoggerServiceType
    let api: APIServiceType

    // MARK: - Initialization

    init(logger: LoggerServiceType, api: APIServiceType) {
        self.logger = logger
        self.api = api
    }

}
