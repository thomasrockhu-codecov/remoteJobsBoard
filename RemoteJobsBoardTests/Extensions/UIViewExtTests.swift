@testable import RemoteJobsBoard
import XCTest

final class UIViewExtTests: XCTestCase {

    // MARK: - Tests

    func test_marginAnchors() {
        let view = UIView()
        XCTAssertTrue(view.leadingMarginAnchor === view.layoutMarginsGuide.leadingAnchor)
        XCTAssertTrue(view.trailingMarginAnchor === view.layoutMarginsGuide.trailingAnchor)
        XCTAssertTrue(view.bottomMarginAnchor === view.layoutMarginsGuide.bottomAnchor)
        XCTAssertTrue(view.topMarginAnchor === view.layoutMarginsGuide.topAnchor)
        XCTAssertTrue(view.centerYMarginAnchor === view.layoutMarginsGuide.centerYAnchor)
        XCTAssertTrue(view.centerXMarginAnchor === view.layoutMarginsGuide.centerXAnchor)
    }

    func test_safeAreaAnchors() {
        let view = UIView()
        XCTAssertTrue(view.leadingSafeAnchor === view.safeAreaLayoutGuide.leadingAnchor)
        XCTAssertTrue(view.trailingSafeAnchor === view.safeAreaLayoutGuide.trailingAnchor)
        XCTAssertTrue(view.bottomSafeAnchor === view.safeAreaLayoutGuide.bottomAnchor)
        XCTAssertTrue(view.topSafeAnchor === view.safeAreaLayoutGuide.topAnchor)
        XCTAssertTrue(view.centerYSafeAnchor === view.safeAreaLayoutGuide.centerYAnchor)
        XCTAssertTrue(view.centerXSafeAnchor === view.safeAreaLayoutGuide.centerXAnchor)
    }

    func test_addToView() {
        let parentView = UIView()
        let childView = UIView()
        let constraint = childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor)

        childView.add(to: parentView) { _, _ in
            constraint
        }

        XCTAssertFalse(childView.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(parentView.subviews, [childView])
        XCTAssertEqual(parentView.constraints, [constraint])
    }

    func test_addAsArrangedSubview() {
        let parentView = UIStackView()
        let childView = UIView()
        let constraint = childView.heightAnchor.constraint(equalToConstant: 44)

        childView.addAsArrangedSubview(to: parentView) { _, _ in
            constraint
        }

        XCTAssertFalse(childView.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(parentView.arrangedSubviews, [childView])
        XCTAssertEqual(parentView.constraints, [constraint])
    }

    func test_addAsArrangedSubview_noConstraints() {
        let parentView = UIStackView()
        let childView = UIView()

        childView.addAsArrangedSubview(to: parentView)

        XCTAssertFalse(childView.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(parentView.arrangedSubviews, [childView])
        XCTAssertTrue(parentView.constraints.isEmpty)
    }

}
