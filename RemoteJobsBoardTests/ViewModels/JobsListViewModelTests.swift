@testable import RemoteJobsBoard
import XCoordinator
import XCTest

final class JobsListViewModelTests: BaseViewModelTest {

    // MARK: - Properties

    private var viewModel: JobsListViewModel!
    private var coordinator: MockCoordinator!

    // MARK: - Base Class

    override func setUp() {
        super.setUp()

        coordinator = MockCoordinator()
        viewModel = JobsListViewModel(router: coordinator.weakRouter, services: services)
    }

    // MARK: - Tests

    // swiftlint:disable:next function_body_length
    func test_loadingFlow() throws {
        let mockJobs = try getMockJSONFullJobs()

        let sinkExpectation0 = expectation(description: "sinkExpectation0")
        let sinkExpectation1 = expectation(description: "sinkExpectation1")
        let sinkExpectation2 = expectation(description: "sinkExpectation2")
        let sinkExpectation3 = expectation(description: "sinkExpectation3")
        let sinkExpectation4 = expectation(description: "sinkExpectation4")
        let sinkExpectation5 = expectation(description: "sinkExpectation5")

        var counter = 0

        viewModel.outputs.jobs
            .sink {
                switch counter {
                case 0:
                    XCTAssert($0.isEmpty)
                    sinkExpectation0.fulfill()
                case 1:
                    XCTAssert($0.isEmpty)
                    sinkExpectation1.fulfill()
                case 2:
                    let expected = Array(mockJobs.prefix(20))
                    XCTAssertEqual($0, expected)

                    sinkExpectation2.fulfill()
                case 3:
                    let expected = Array(mockJobs.prefix(40))
                    XCTAssertEqual($0, expected)

                    sinkExpectation3.fulfill()
                case 4:
                    let expected = Array(mockJobs.prefix(60))
                    XCTAssertEqual($0, expected)

                    sinkExpectation4.fulfill()
                case 5:
                    let expected = Array(mockJobs.prefix(20))
                    XCTAssertEqual($0, expected)

                    sinkExpectation5.fulfill()
                default:
                    XCTFail("Unexpected sink index - \(counter)")
                }

                counter += 1
            }
            .store(in: &subscriptionsStore)

        viewModel.bind()
        wait(for: [sinkExpectation0, sinkExpectation1, sinkExpectation2], timeout: Constant.waitTimeout)

        viewModel.inputs.increasePage()
        wait(for: [sinkExpectation3], timeout: Constant.waitTimeout)

        viewModel.inputs.increasePage()
        wait(for: [sinkExpectation4], timeout: Constant.waitTimeout)

        viewModel.inputs.reloadData()
        wait(for: [sinkExpectation5], timeout: Constant.waitTimeout)
    }

    // swiftlint:disable:next function_body_length
    func test_search() throws {
        let mockJobs = try getMockJSONFullJobs()
        let filteredMockJobs1 = mockJobs
            .filter {
                $0.companyName.localizedCaseInsensitiveContains(Constant.searchText1)
                    || $0.title.localizedCaseInsensitiveContains(Constant.searchText1)
            }
        let filteredMockJobs2 = mockJobs
            .filter {
                $0.companyName.localizedCaseInsensitiveContains(Constant.searchText2)
                    || $0.title.localizedCaseInsensitiveContains(Constant.searchText2)
            }

        let sinkExpectation0 = expectation(description: "sinkExpectation0")
        let sinkExpectation1 = expectation(description: "sinkExpectation1")
        let sinkExpectation2 = expectation(description: "sinkExpectation2")
        let sinkExpectation3 = expectation(description: "sinkExpectation3")
        let sinkExpectation4 = expectation(description: "sinkExpectation4")
        let sinkExpectation5 = expectation(description: "sinkExpectation5")
        let sinkExpectation6 = expectation(description: "sinkExpectation6")
        let sinkExpectation7 = expectation(description: "sinkExpectation7")
        let sinkExpectation8 = expectation(description: "sinkExpectation8")

        var counter = 0

        viewModel.outputs.searchResultJobs
            .sink {
                switch counter {
                case 0:
                    XCTAssert($0.isEmpty)
                    sinkExpectation0.fulfill()
                case 1:
                    XCTAssert($0.isEmpty)
                    sinkExpectation1.fulfill()
                case 2:
                    let expected = Array(mockJobs.prefix(20))
                    XCTAssertEqual($0, expected)

                    sinkExpectation2.fulfill()
                case 3:
                    let expected = Array(filteredMockJobs1.prefix(20))
                    XCTAssertEqual($0, expected)

                    sinkExpectation3.fulfill()
                case 4:
                    let expected = Array(filteredMockJobs1.prefix(40))
                    XCTAssertEqual($0, expected)

                    sinkExpectation4.fulfill()
                case 5:
                    let expected = Array(filteredMockJobs2.prefix(20))
                    XCTAssertEqual($0, expected)

                    sinkExpectation5.fulfill()
                case 6:
                    XCTAssertTrue($0.isEmpty)
                    sinkExpectation6.fulfill()
                case 7:
                    let expected = Array(mockJobs.prefix(20))
                    XCTAssertEqual($0, expected)

                    sinkExpectation7.fulfill()
                case 8:
                    let expected = Array(mockJobs.prefix(20))
                    XCTAssertEqual($0, expected)

                    sinkExpectation8.fulfill()
                default:
                    XCTFail("Unexpected sink index - \(counter)")
                }

                counter += 1
            }
            .store(in: &subscriptionsStore)

        viewModel.bind()
        wait(for: [sinkExpectation0, sinkExpectation1, sinkExpectation2], timeout: Constant.waitTimeout)

        viewModel.inputs.searchText.accept(Constant.searchText1)
        wait(for: [sinkExpectation3], timeout: Constant.waitTimeout)

        viewModel.inputs.increaseSearchPage()
        wait(for: [sinkExpectation4], timeout: Constant.waitTimeout)

        viewModel.inputs.searchText.accept(Constant.searchText2)
        wait(for: [sinkExpectation5], timeout: Constant.waitTimeout)

        viewModel.inputs.searchText.accept(Constant.searchText3)
        wait(for: [sinkExpectation6], timeout: Constant.waitTimeout)

        viewModel.inputs.searchText.accept("")
        wait(for: [sinkExpectation7], timeout: Constant.waitTimeout)

        viewModel.inputs.searchText.accept(nil)
        wait(for: [sinkExpectation8], timeout: Constant.waitTimeout)
    }

    func test_route() throws {
        viewModel.bind()

        let showJobDetailsExpectation = expectation(description: "showJobDetailsExpectation")
        coordinator.showJobDetailsExpectation = showJobDetailsExpectation

        XCTAssertEqual(coordinator.latestRoute, .initial)

        let job = try getMockJSONFullJobs()[0]
        viewModel.inputs.showJobDetails.accept(job)
        wait(for: [showJobDetailsExpectation], timeout: Constant.waitTimeout)
        XCTAssertEqual(coordinator.latestRoute, .showJobDetails(job))
    }

}

// MARK: - Helpers

private extension JobsListViewModelTests {

    func getMockJSONFullJobs() throws -> [Job] {
        let data = try MockJSONLoader.loadJSON(named: MockJSON.full.fileName)
        let decoded = try JSONDecoder().decode(APIService.JobsResponseModel.self, from: data)
        return decoded.jobs.map { Job(apiModel: $0) }
    }

}

// MARK: - Constants

private extension JobsListViewModelTests {

    enum Constant {

        static let waitTimeout: TimeInterval = 5
        static let searchText1 = "QA Engineer"
        static let searchText2 = "Software"
        static let searchText3 = "No results search text 🤔"

    }

}

// MARK: - MockCoordinator

private class MockCoordinator: NavigationCoordinator<JobsListCoordinator.RouteModel> {

    var latestRoute: JobsListCoordinator.RouteModel?

    var showJobDetailsExpectation: XCTestExpectation?

    init() {
        super.init(rootViewController: UINavigationController(), initialRoute: .initial)
    }

    override func prepareTransition(for route: JobsListCoordinator.RouteModel) -> NavigationTransition {
        latestRoute = route

        switch route {
        case .initial:
            break
        case .showJobDetails:
            showJobDetailsExpectation?.fulfill()
        }

        return .none()
    }

}

// MARK: - JobsListCoordinator.RouteModel Equatable

extension JobsListCoordinator.RouteModel: Equatable {

    public static func == (lhs: JobsListCoordinator.RouteModel, rhs: JobsListCoordinator.RouteModel) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.showJobDetails(let lhsJob), .showJobDetails(let rhsJob)):
            return lhsJob == rhsJob
        default:
            return false
        }
    }

}
