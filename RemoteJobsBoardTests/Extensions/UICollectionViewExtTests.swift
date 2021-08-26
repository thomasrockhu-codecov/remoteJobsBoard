import Combine
import XCTest
@testable import RemoteJobsBoard

final class UICollectionViewExtTests: XCTestCase {

    // MARK: - Typealiases

    private typealias Kind = UICollectionView.ReusableSupplementaryViewKind

    // MARK: - Properties

    private var viewController: MockViewController!

    // MARK: - Base Class

    override func setUp() {
        super.setUp()

        viewController = MockViewController()
    }

    // MARK: - Tests

    func test_cell_success() throws {
        guard let collectionView = viewController.collectionView else { throw TestError.nilCollectionView }
        guard let dataSource = collectionView.dataSource else { throw TestError.nilDataSource }

        collectionView.register(cellClass: MockCollectionViewCell.self)

        let cell = dataSource.collectionView(collectionView, cellForItemAt: Constant.indexPath)
        XCTAssertNil(viewController.error)
        XCTAssertNotNil(cell)
    }

    func test_cell_error() throws {
        guard let collectionView = viewController.collectionView else { throw TestError.nilCollectionView }
        guard let dataSource = collectionView.dataSource else { throw TestError.nilDataSource }

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constant.cellIdentifier)

        let cell = dataSource.collectionView(collectionView, cellForItemAt: Constant.indexPath)
        XCTAssertEqual(viewController.error, TestError.dequeueError(Constant.cellIdentifier))
        XCTAssertNotNil(cell)
    }

    func test_supplementary_success_header() throws {
        try testSupplementaryView(for: .header)
    }

    func test_supplementary_success_footer() throws {
        try testSupplementaryView(for: .footer)
    }

    func test_supplementary_error_header() throws {
        try testSupplementaryViewFailure(for: .header)
    }

    func test_supplementary_error_footer() throws {
        try testSupplementaryViewFailure(for: .footer)
    }

    func test_reusableSupplementaryViewKind() {
        var kind = UICollectionView.ReusableSupplementaryViewKind.footer
        XCTAssertEqual(kind.rawValue, UICollectionView.elementKindSectionFooter)

        kind = .header
        XCTAssertEqual(kind.rawValue, UICollectionView.elementKindSectionHeader)
    }

}

// MARK: - Helpers

private extension UICollectionViewExtTests {

    func testSupplementaryView(for kind: UICollectionView.ReusableSupplementaryViewKind) throws {
        guard let collectionView = viewController.collectionView else { throw TestError.nilCollectionView }
        guard let dataSource = collectionView.dataSource else { throw TestError.nilDataSource }

        collectionView.register(cellClass: MockCollectionViewCell.self)
        collectionView.register(viewClass: MockCollectionReusableView.self, forKind: kind)
        collectionView.reloadItems(at: [Constant.indexPath])

        let view = dataSource.collectionView?(collectionView,
                                              viewForSupplementaryElementOfKind: kind.rawValue,
                                              at: Constant.indexPath)

        XCTAssertNil(viewController.error)
        XCTAssertNotNil(view)
    }

    func testSupplementaryViewFailure(for kind: UICollectionView.ReusableSupplementaryViewKind) throws {
        guard let collectionView = viewController.collectionView else { throw TestError.nilCollectionView }
        guard let dataSource = collectionView.dataSource else { throw TestError.nilDataSource }

        collectionView.register(cellClass: MockCollectionViewCell.self)
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: kind.rawValue,
                                withReuseIdentifier: Constant.viewIdentifier)
        collectionView.reloadItems(at: [Constant.indexPath])

        let view = dataSource.collectionView?(collectionView,
                                              viewForSupplementaryElementOfKind: kind.rawValue,
                                              at: Constant.indexPath)
        XCTAssertEqual(viewController.error, TestError.dequeueError(Constant.viewIdentifier))
        XCTAssertNotNil(view)
    }

}

// MARK: - Constants

private extension UICollectionViewExtTests {

    enum Constant {

        static let indexPath = IndexPath(row: 0, section: 0)
        static let cellIdentifier = "MockCollectionViewCell"
        static let viewIdentifier = "MockCollectionReusableView"

    }

}

// MARK: - Test Error

private enum TestError: Error, Equatable {

    case nilCollectionView
    case nilDataSource
    case dequeueError(String)
    case unknown(Error)
    case unexpectedIdentifier(String)

    static func == (lhs: TestError, rhs: TestError) -> Bool {
        switch (lhs, rhs) {
        case (.nilCollectionView, .nilCollectionView), (.nilDataSource, .nilDataSource):
            return true
        case let (.dequeueError(lhsID), .dequeueError(rhsID)):
            return lhsID == rhsID
        case let (.unexpectedIdentifier(lhsID), .unexpectedIdentifier(rhsID)):
            return lhsID == rhsID
        default:
            return false
        }
    }

}

// MARK: - Mock View Controller

// swiftlint:disable line_length
private final class MockViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var error: TestError?

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 30, height: 30)
        layout.footerReferenceSize = CGSize(width: 40, height: 40)
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        do {
            let cell: MockCollectionViewCell = try collectionView.dequeueReusableCell(for: indexPath)
            return cell
        } catch let dequeueError as CommonError {
            switch dequeueError {
            case .collectionViewCellDequeue(identifier: let identifier):
                self.error = .dequeueError(identifier)
            default:
                self.error = .unknown(dequeueError)
            }
            return MockCollectionViewCell()
        } catch {
            self.error = .unknown(error)
            return MockCollectionViewCell()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        do {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let view: MockCollectionReusableView = try collectionView.dequeueReusableSupplementaryView(ofKind: .header, for: indexPath)
                return view
            case UICollectionView.elementKindSectionFooter:
                let view: MockCollectionReusableView = try collectionView.dequeueReusableSupplementaryView(ofKind: .footer, for: indexPath)
                return view
            default:
                self.error = .unexpectedIdentifier(kind)
                return MockCollectionReusableView()
            }
        } catch let dequeueError as CommonError {
            switch dequeueError {
            case .collectionViewSupplementaryViewDequeue(identifier: let identifier):
                self.error = .dequeueError(identifier)
            default:
                self.error = .unknown(dequeueError)
            }
            return MockCollectionReusableView()
        } catch {
            self.error = .unknown(error)
            return MockCollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: 40, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: 30, height: 30)
    }

}

// MARK: - Mock Collection View Cell

private final class MockCollectionViewCell: UICollectionViewCell {}

// MARK: - Mock Collection Reusable View

private final class MockCollectionReusableView: UICollectionReusableView {}
// swiftlint:enable line_length
