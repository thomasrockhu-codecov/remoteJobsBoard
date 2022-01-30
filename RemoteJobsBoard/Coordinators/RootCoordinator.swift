import UIKit
import XCoordinator

final class RootCoordinator: BaseNavigationCoordinator<RootCoordinator.RouteModel> {

	// MARK: - Initialization

	init(services: ServicesContainer) {
		super.init(
			services: services,
			initialRoute: .initial,
			rootViewController: JobsListNavigationController()
		)
	}

	// MARK: - Base Class

	override func prepareTransition(for route: RouteModel) -> NavigationTransition {
		switch route {
		case .initial:
			let viewModel = JobsListViewModel(router: weakRouter, services: services)
			let searchResultsController = JobsListSearchResultsController(services: services, viewModel: viewModel)
			let controller = JobsListViewController(services: services, viewModel: viewModel, searchResultsController: searchResultsController)
			return .push(controller, animation: nil)
		case .showJobDetails(let job):
			let viewModel = JobDetailsViewModel(job: job, router: weakRouter, services: services)
			let controller = JobDetailsViewController(viewModel: viewModel, services: services)
			return .push(controller)
		case .webPage(let url):
			guard UIApplication.shared.canOpenURL(url) else { return .none() }
			UIApplication.shared.open(url)
			return .none()
		case .phoneNumber(let phoneNumber):
			guard
				let url = URL(string: "tel://\(phoneNumber)"),
				UIApplication.shared.canOpenURL(url)
			else {
				return .none()
			}
			UIApplication.shared.open(url)
			return .none()
		case let .showCategoryJobs(category: category, jobs: jobs):
			let viewModel = JobCategoryJobsListViewModel(category: category, jobs: jobs, router: weakRouter, services: services)
			let searchResultsController = JobsListSearchResultsController(services: services, viewModel: viewModel)
			let viewController = JobCategoryJobsListViewController(viewModel: viewModel, services: services, searchResultsController: searchResultsController)
			return .push(viewController)
		}
	}

}

// MARK: - RouteModel

extension RootCoordinator {

	enum RouteModel: Route, Equatable {

		case initial
		case showJobDetails(Job)
		case showCategoryJobs(category: Job.Category, jobs: [Job])
		case webPage(URL)
		case phoneNumber(String)

	}

}
