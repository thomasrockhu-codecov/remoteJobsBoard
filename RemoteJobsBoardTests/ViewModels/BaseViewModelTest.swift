import Combine
import CombineExtensions
@testable import RemoteJobsBoard
import XCTest

/// Base class for all view model tests.
/// This class must not be final.
class BaseViewModelTest: XCTestCase {

    // MARK: - Properties

    // swiftlint:disable implicitly_unwrapped_optional
    private(set) var subscriptions: CombineCancellable!
    private(set) var services: ServicesContainer!
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - Base Class

    override func setUp() {
        super.setUp()

        subscriptions = CombineCancellable()
        services = ServicesContainer(
            logger: MockLoggerService(),
            api: MockAPIService()
        )
    }

}
