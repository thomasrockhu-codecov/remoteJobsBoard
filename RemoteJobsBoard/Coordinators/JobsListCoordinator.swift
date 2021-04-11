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
            let controller = JobsListViewController(services: services, viewModel: viewModel)
            return .push(controller, animation: nil)
        }
    }

}

// MARK: - RouteModel

extension JobsListCoordinator {

    enum RouteModel: Route {

        case initial

    }

}
