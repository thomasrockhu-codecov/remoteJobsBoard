import Combine
import XCTest
@testable import RemoteJobsBoard

final class UITableViewExtTests: XCTestCase {

    // MARK: - Properties

    private var viewController: MockViewController!

    // MARK: - Base Class

    override func setUp() {
        super.setUp()

        viewController = MockViewController()
    }

    // MARK: - Tests

    func test_cell_success() throws {
        guard let tableView = viewController.tableView else {
            throw TestError.nilTableView
        }
        tableView.register(cellClass: MockTableViewCell.self)

        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: Constant.indexPath)
        XCTAssertNil(viewController.error)
        XCTAssertNotNil(cell)
    }

    func test_cell_error() throws {
        guard let tableView = viewController.tableView else {
            throw TestError.nilTableView
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.cellIdentifier)

        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: Constant.indexPath)
        XCTAssertEqual(viewController.error, TestError.dequeueError(Constant.cellIdentifier))
        XCTAssertNotNil(cell)
    }

    func test_headerFooter_success() throws {
        guard let tableView = viewController.tableView else {
            throw TestError.nilTableView
        }
        tableView.register(headerFooterClass: MockHeaderFooterView.self)

        let view = viewController.tableView(tableView, viewForHeaderInSection: 0)
        XCTAssertNil(viewController.error)
        XCTAssertNotNil(view)
    }

    func test_headerFooter_error() throws {
        guard let tableView = viewController.tableView else {
            throw TestError.nilTableView
        }
        tableView.register(UITableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: Constant.viewIdentifier)

        let view = viewController.tableView(tableView, viewForHeaderInSection: 0)
        XCTAssertEqual(viewController.error, TestError.dequeueError(Constant.viewIdentifier))
        XCTAssertNil(view)
    }

}

// MARK: - Constants

private extension UITableViewExtTests {

    enum Constant {

        static let indexPath = IndexPath(row: 0, section: 0)
        static let cellIdentifier = "MockTableViewCell"
        static let viewIdentifier = "MockHeaderFooterView"

    }

}

// MARK: - Test Error

private enum TestError: Error, Equatable {

    case nilTableView
    case dequeueError(String)
    case unknown(Error)

    static func == (lhs: TestError, rhs: TestError) -> Bool {
        switch (lhs, rhs) {
        case (.nilTableView, .nilTableView):
            return true
        case let (.dequeueError(lhsID), .dequeueError(rhsID)):
            return lhsID == rhsID
        default:
            return false
        }
    }

}

// MARK: - Mock View Controller

private final class MockViewController: UITableViewController {

    var error: TestError?

    init() {
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        do {
            let cell: MockTableViewCell = try tableView.dequeueReusableCell(for: indexPath)
            return cell
        } catch let dequeueError as CommonError {
            switch dequeueError {
            case .tableViewCellDequeue(identifier: let identifier):
                self.error = .dequeueError(identifier)
            default:
                self.error = .unknown(dequeueError)
            }
            return MockTableViewCell()
        } catch {
            self.error = .unknown(error)
            return MockTableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        do {
            let view: MockHeaderFooterView = try tableView.dequeueReusableHeaderFooterView()
            return view
        } catch let dequeueError as CommonError {
            switch dequeueError {
            case .tableViewHeaderFooterViewDequeue(identifier: let identifier):
                self.error = .dequeueError(identifier)
            default:
                self.error = .unknown(dequeueError)
            }
            return nil
        } catch {
            self.error = .unknown(error)
            return nil
        }
    }

}

// MARK: - Mock Table View Cell

private final class MockTableViewCell: UITableViewCell {}

// MARK: - Mock Header Footer View

private final class MockHeaderFooterView: UITableViewHeaderFooterView {}
