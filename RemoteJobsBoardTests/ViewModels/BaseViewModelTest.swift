import Combine
import CombineExt
@testable import RemoteJobsBoard
import XCTest

/// Base class for all view model tests.
/// This class must not be final.
class BaseViewModelTest: XCTestCase {

    // MARK: - Properties

    // swiftlint:disable implicitly_unwrapped_optional
    var subscriptionsStore: SubscriptionsStore!
    private(set) var services: ServicesContainer!
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - Base Class

    override func setUp() {
        super.setUp()

        subscriptionsStore = SubscriptionsStore()
        services = ServicesContainer(
            logger: MockLoggerService(),
            api: MockAPIService()
        )
    }

}
