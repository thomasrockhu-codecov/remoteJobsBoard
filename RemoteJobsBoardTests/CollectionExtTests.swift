@testable import RemoteJobsBoard
import XCTest

final class CollectionExtTests: XCTestCase {

    // MARK: - Tests

    func test_safe() {
        let collection = [1, 2, 3]

        XCTAssertEqual(collection[safe: 0], collection[0])
        XCTAssertEqual(collection[safe: 1], collection[1])
        XCTAssertEqual(collection[safe: 2], collection[2])
        XCTAssertNil(collection[safe: 3])
        XCTAssertNil(collection[safe: 10])
    }

}
