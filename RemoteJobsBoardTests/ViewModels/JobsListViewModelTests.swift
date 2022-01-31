@testable import RemoteJobsBoard
import XCoordinator
import XCTest

final class JobsListViewModelTests: BaseViewModelTest {

	// MARK: - Typealiases

	fileprivate typealias ViewModel = JobsList.ViewModel

	// MARK: - Properties

	private var viewModel: ViewModel!
	private var coordinator: MockCoordinator!

	// MARK: - Base Class

	override func setUp() {
		super.setUp()

		coordinator = MockCoordinator()
		viewModel = ViewModel(router: coordinator.weakRouter, services: services)
	}

	// MARK: - Tests

	func test_loadingFlow() throws {
		let mockJobs = try getMockJSONFullJobs()

		let expectations = [
			expectation(description: "sinkExpectation0"),
			expectation(description: "sinkExpectation1"),
			expectation(description: "sinkExpectation2"),
			expectation(description: "sinkExpectation3"),
			expectation(description: "sinkExpectation4")
		]

		var counter = 0
		viewModel.output.jobs
			.sink {
				switch counter {
				case 0:
					XCTAssert($0.isEmpty)
				case 1, 2, 3:
					let expected = Array(mockJobs.prefix(Constant.itemsPerPage * counter))
					XCTAssertEqual($0, expected)
				case 4:
					let expected = Array(mockJobs.prefix(Constant.itemsPerPage))
					XCTAssertEqual($0, expected)
				default:
					XCTFail("Unexpected sink index - \(counter)")
				}

				expectations[safe: counter]?.fulfill()
				counter += 1
			}
			.store(in: subscriptions)

		viewModel.bind()
		wait(for: [expectations[0], expectations[1]], timeout: Constant.waitTimeout)

		viewModel.input.showNextPage.accept()
		wait(for: [expectations[2]], timeout: Constant.waitTimeout)

		viewModel.input.showNextPage.accept()
		wait(for: [expectations[3]], timeout: Constant.waitTimeout)

		viewModel.input.reloadData.accept()
		wait(for: [expectations[4]], timeout: Constant.waitTimeout)
	}

	// swiftlint:disable:next function_body_length
	func test_search() throws {
		let mockJobs = try getMockJSONFullJobs()
		let filteredMockJobs1 = mockJobs.filter { isJobMatched($0, comparedTo: Constant.searchText1) }
		let filteredMockJobs2 = mockJobs.filter { isJobMatched($0, comparedTo: Constant.searchText2) }

		let expectations = [
			expectation(description: "sinkExpectation0"),
			expectation(description: "sinkExpectation1"),
			expectation(description: "sinkExpectation2"),
			expectation(description: "sinkExpectation3"),
			expectation(description: "sinkExpectation4")
		]

		var counter = 0
		viewModel.searchResultsOutput.searchResultJobs
			.sink {
				switch counter {
				case 0, 4:
					XCTAssert($0.isEmpty)
				case 1:
					let expected = Array(filteredMockJobs1.prefix(Constant.itemsPerPage))
					XCTAssertEqual($0, expected)
				case 2:
					let expected = Array(filteredMockJobs1.prefix(Constant.itemsPerPage * 2))
					XCTAssertEqual($0, expected)
				case 3:
					let expected = Array(filteredMockJobs2.prefix(Constant.itemsPerPage))
					XCTAssertEqual($0, expected)
				default:
					XCTFail("Unexpected sink index - \(counter)")
				}

				expectations[safe: counter]?.fulfill()
				counter += 1
			}
			.store(in: subscriptions)

		viewModel.bind()
		wait(for: [expectations[0]], timeout: Constant.waitTimeout)

		viewModel.searchResultsInput.searchText.accept(Constant.searchText1)
		wait(for: [expectations[1]], timeout: Constant.waitTimeout)

		viewModel.searchResultsInput.showNextSearchPage.accept()
		wait(for: [expectations[2]], timeout: Constant.waitTimeout)

		viewModel.searchResultsInput.searchText.accept(Constant.searchText2)
		wait(for: [expectations[3]], timeout: Constant.waitTimeout)

		viewModel.searchResultsInput.searchText.accept(Constant.searchText3)
		wait(for: [expectations[4]], timeout: Constant.waitTimeout)

		viewModel.searchResultsInput.searchText.accept("")
		viewModel.searchResultsInput.searchText.accept(nil)

		sleep(1)
	}

	// MARK: - Tests - Route

	func test_route_showJobDetails() throws {
		viewModel.bind()
		sleep(1)

		let showJobDetailsExpectation = expectation(description: Constant.showJobDetailsExpectation)

		let webPageExpectation = expectation(description: Constant.webPageExpectation)
		webPageExpectation.isInverted = true

		let phoneNumberExpectation = expectation(description: Constant.phoneNumberExpectation)
		phoneNumberExpectation.isInverted = true

		coordinator.showJobDetailsExpectation = showJobDetailsExpectation
		coordinator.webPageExpectation = webPageExpectation
		coordinator.phoneNumberExpectation = phoneNumberExpectation

		XCTAssertEqual(coordinator.latestRoute, .initial)

		let job = try getMockJSONFullJobs()[0]
		viewModel.input.showJobDetails.accept(job)
		wait(for: [showJobDetailsExpectation], timeout: Constant.waitTimeout)
		XCTAssertEqual(coordinator.latestRoute, .showJobDetails(job))

		wait(for: [webPageExpectation, phoneNumberExpectation], timeout: Constant.waitTimeout)
	}

	func test_route_showCategoryJobs() throws {
		viewModel.bind()
		sleep(1)

		let showCategoryJobsExpectation = expectation(description: Constant.showCategoryJobsExpectation)

		let webPageExpectation = expectation(description: Constant.webPageExpectation)
		webPageExpectation.isInverted = true

		let phoneNumberExpectation = expectation(description: Constant.phoneNumberExpectation)
		phoneNumberExpectation.isInverted = true

		coordinator.showCategoryJobsExpectation = showCategoryJobsExpectation
		coordinator.webPageExpectation = webPageExpectation
		coordinator.phoneNumberExpectation = phoneNumberExpectation

		XCTAssertEqual(coordinator.latestRoute, .initial)

		viewModel.input.showCategoryJobs.accept(.softwareDevelopment)
		wait(for: [showCategoryJobsExpectation], timeout: Constant.waitTimeout)

		let jobs = try getMockJSONFullJobs().filter { $0.category == .softwareDevelopment }
		XCTAssertEqual(coordinator.latestRoute, .showCategoryJobs(category: .softwareDevelopment, jobs: jobs))

		wait(for: [webPageExpectation, phoneNumberExpectation], timeout: Constant.waitTimeout)
	}

}

// MARK: - Helpers

private extension JobsListViewModelTests {

	func isJobMatched(_ job: Job, comparedTo searchText: String) -> Bool {
		job.companyName.localizedCaseInsensitiveContains(searchText)
		|| job.title.localizedCaseInsensitiveContains(searchText)
	}

	func getMockJSONFullJobs() throws -> [Job] {
		let data = try MockJSONLoader.loadJSON(named: MockJSON.huge.fileName)
		let decoded = try JSONDecoder().decode(APIService.JobsResponseModel.self, from: data)
		return decoded.jobs.map { Job(apiModel: $0) }
	}

}

// MARK: - Constants

private extension JobsListViewModelTests {

	enum Constant {

		static let itemsPerPage = 20
		static let waitTimeout: TimeInterval = 1
		static let searchText1 = "QA"
		static let searchText2 = "Software"
		static let searchText3 = "No results search text 🤔"

		static let webPageExpectation = "webPageExpectation"
		static let phoneNumberExpectation = "phoneNumberExpectation"
		static let showCategoryJobsExpectation = "showCategoryJobsExpectation"
		static let showJobDetailsExpectation = "showJobDetailsExpectation"

	}

}
