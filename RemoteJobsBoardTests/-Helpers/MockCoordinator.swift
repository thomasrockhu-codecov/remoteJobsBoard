@testable import RemoteJobsBoard
import XCoordinator
import XCTest

final class MockCoordinator: NavigationCoordinator<RootCoordinator.RouteModel> {

	var latestRoute: RootCoordinator.RouteModel?

	var showJobDetailsExpectation: XCTestExpectation?
	var showCategoryJobsExpectation: XCTestExpectation?
	var phoneNumberExpectation: XCTestExpectation?
	var webPageExpectation: XCTestExpectation?

	init() {
		super.init(rootViewController: UINavigationController(), initialRoute: .initial)
	}

	override func prepareTransition(for route: RootCoordinator.RouteModel) -> NavigationTransition {
		latestRoute = route

		switch route {
		case .initial:
			break
		case .showJobDetails:
			showJobDetailsExpectation?.fulfill()
		case .phoneNumber:
			phoneNumberExpectation?.fulfill()
		case .webPage:
			webPageExpectation?.fulfill()
		case .showCategoryJobs:
			showCategoryJobsExpectation?.fulfill()
		}

		return .none()
	}

}
