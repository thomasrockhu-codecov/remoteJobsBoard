import UIKit
import XCoordinator

final class RootCoordinator: BaseNavigationCoordinator<RootCoordinator.RouteModel> {

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
            let controller = JobsListViewController(services: services, viewModel: viewModel)
            return .push(controller, animation: nil)
        case .showJobDetails(let job):
            let viewModel = JobDetailViewModel(job: job, router: weakRouter, services: services)
            let controller = JobDetailsViewController(viewModel: viewModel, services: services)
            return .push(controller)
        }
    }

}

// MARK: - RouteModel

extension RootCoordinator {

    enum RouteModel: Route {

        case initial
        case showJobDetails(Job)

    }

}
