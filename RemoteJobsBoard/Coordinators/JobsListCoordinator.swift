import UIKit
import XCoordinator

final class JobsListCoordinator: BaseNavigationCoordinator<JobsListCoordinator.RouteModel> {

    // MARK: - Initialization

    init(services: ServicesContainer) {
        super.init(services: services,
                   initialRoute: .initial,
                   rootViewController: JobsListNavigationController())
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
            let coordinator = JobDetailsCoordinator(job: job, services: services)
            return .present(coordinator)
        }
    }

}

// MARK: - RouteModel

extension JobsListCoordinator {

    enum RouteModel: Route {

        case initial
        case showJobDetails(Job)

    }

}
