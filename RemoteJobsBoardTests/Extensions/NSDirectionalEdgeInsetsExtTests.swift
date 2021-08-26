import XCTest
@testable import RemoteJobsBoard

final class NSDirectionalEdgeInsetsExtTests: XCTestCase {

    // MARK: - Tests

    func test_init_1() {
        let horizontal: CGFloat = 10
        let vertical: CGFloat = 20

        let testInset = NSDirectionalEdgeInsets(vertical: vertical, horizontal: horizontal)
        let defaultInset = NSDirectionalEdgeInsets(top: vertical,
                                                   leading: horizontal,
                                                   bottom: vertical,
                                                   trailing: horizontal)

        XCTAssertEqual(testInset.bottom, defaultInset.bottom)
        XCTAssertEqual(testInset.leading, defaultInset.leading)
        XCTAssertEqual(testInset.top, defaultInset.top)
        XCTAssertEqual(testInset.trailing, defaultInset.trailing)
        XCTAssertEqual(testInset.bottom, vertical)
        XCTAssertEqual(testInset.top, vertical)
        XCTAssertEqual(testInset.leading, horizontal)
        XCTAssertEqual(testInset.trailing, horizontal)
    }

    func test_init_2() {
        let inset: CGFloat = 10

        let testInset = NSDirectionalEdgeInsets(inset: inset)
        let defaultInset = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        XCTAssertEqual(testInset.bottom, defaultInset.bottom)
        XCTAssertEqual(testInset.leading, defaultInset.leading)
        XCTAssertEqual(testInset.top, defaultInset.top)
        XCTAssertEqual(testInset.trailing, defaultInset.trailing)
        XCTAssertEqual(testInset.bottom, inset)
        XCTAssertEqual(testInset.top, inset)
        XCTAssertEqual(testInset.leading, inset)
        XCTAssertEqual(testInset.trailing, inset)
    }

}
