import UIKit
import XCoordinator

final class JobDetailsCoordinator: BaseNavigationCoordinator<JobDetailsCoordinator.RouteModel> {

    // MARK: - Properties

    private let job: Job

    // MARK: - Initialization

    init(job: Job, services: ServicesContainer) {
        self.job = job

        super.init(services: services,
                   initialRoute: .initial,
                   rootViewController: JobDetailsNavigationController())
    }

    // MARK: - Base Class

    override func prepareTransition(for route: RouteModel) -> NavigationTransition {
        switch route {
        case .initial:
            let viewModel = JobDetailsViewModel(job: job, router: weakRouter, services: services)
            let controller = JobDetailsViewController(viewModel: viewModel, services: services)
            return .push(controller, animation: nil)
        }
    }

}

// MARK: - RouteModel

extension JobDetailsCoordinator {

    enum RouteModel: Route {

        case initial

    }

}
