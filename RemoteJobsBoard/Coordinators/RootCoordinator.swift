import UIKit
import XCoordinator

final class RootCoordinator: BaseNavigationCoordinator<RootCoordinator.RouteModel> {

	// MARK: - Initialization

	init(services: ServicesContainer) {
		super.init(
			services: services,
			initialRoute: .initial,
			rootViewController: JobsList.NavigationController()
		)
	}

	// MARK: - Base Class

	override func prepareTransition(for route: RouteModel) -> NavigationTransition {
		switch route {
		case .initial:
			return initialTransition()
		case .showJobDetails(let job):
			return showJobDetailsTransition(job)
		case .webPage(let url):
			return webPageTransition(with: url)
		case .phoneNumber(let phoneNumber):
			return phoneNumberTransition(with: phoneNumber)
		case let .showCategoryJobs(category: category, jobs: jobs):
			return showCategoryJobsTransition(category: category, jobs: jobs)
		}
	}

}

// MARK: - Private Methods

private extension RootCoordinator {

	func initialTransition() -> NavigationTransition {
		let viewModel = JobsList.ViewModel(router: weakRouter, services: services)
		let searchResultsController = JobsSearch.ResultsController(services: services, viewModel: viewModel)
		let controller = JobsList.ViewController(services: services, viewModel: viewModel, searchResultsController: searchResultsController)
		return .push(controller, animation: nil)
	}

	func showJobDetailsTransition(_ job: Job) -> NavigationTransition {
		typealias N = JobDetails

		let viewModel = N.ViewModel(job: job, router: weakRouter, services: services)
		let controller = N.ViewController(viewModel: viewModel, services: services)
		return .push(controller)
	}

	func webPageTransition(with url: URL) -> NavigationTransition {
		guard UIApplication.shared.canOpenURL(url) else { return .none() }

		UIApplication.shared.open(url)
		return .none()
	}

	func phoneNumberTransition(with phoneNumber: String) -> NavigationTransition {
		guard let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else {
			return .none()
		}

		UIApplication.shared.open(url)
		return .none()
	}

	func showCategoryJobsTransition(category: Job.Category, jobs: [Job]) -> NavigationTransition {
		let viewModel = JobCategoryJobsList.ViewModel(
			category: category,
			jobs: jobs,
			router: weakRouter,
			services: services
		)
		let searchResultsController = JobsSearch.ResultsController(services: services, viewModel: viewModel)
		let viewController = JobCategoryJobsList.ViewController(
			viewModel: viewModel,
			services: services,
			searchResultsController: searchResultsController
		)
		return .push(viewController)
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
