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
        }
    }

}

// MARK: - RouteModel

extension JobDetailsCoordinator {

    enum RouteModel: Route {

        case initial
        case webPage(URL)
        case phoneNumber(String)

    }

}
