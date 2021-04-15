import Combine
import Foundation

final class JobDetailViewModel: BaseViewModel<RootCoordinator.RouteModel> {

    // MARK: - Properties

    private let outputsRelay: OutputsRelay

    // MARK: - Initialization

    init(job: Job, router: Router, services: ServicesContainer) {
        outputsRelay = OutputsRelay(job: job)

        super.init(router: router, services: services)
    }

}

// MARK: - JobsListViewModelType

extension JobDetailViewModel: JobDetailViewModelType, JobDetailViewModelTypeInputs {

    var inputs: JobDetailViewModelTypeInputs { self }
    var outputs: JobDetailViewModelTypeOutputs { outputsRelay }

}
