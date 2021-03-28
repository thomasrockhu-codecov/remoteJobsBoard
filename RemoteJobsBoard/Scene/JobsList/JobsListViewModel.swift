import Combine
import Foundation

final class JobsListViewModel: BaseViewModel<JobsListCoordinator.RouteModel> {

    // MARK: - Properties

    private let api: APIServiceType

    private let inputsRelay = InputsRelay()
    private let outputsRelay = OutputsRelay()

    // MARK: - Initialization

    override init(router: Router, services: ServicesContainer) {
        api = services.api

        super.init(router: router, services: services)
    }

    // MARK: - Base Class

    override func bind() {
        super.bind()

        api.getJobs()
            .catch(errorHandler: errorHandler)
            .subscribe(outputsRelay.jobsRelay)
            .store(in: &subscriptionsStore)
    }

}

// MARK: - JobsListViewModelType

extension JobsListViewModel: JobsListViewModelType {

    var inputs: JobsListViewModelTypeInputs { inputsRelay }
    var outputs: JobsListViewModelTypeOutputs { outputsRelay }

}
