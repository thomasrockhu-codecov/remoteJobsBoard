import Combine
import Foundation

final class JobsListViewModel: BaseViewModel<RootCoordinator.RouteModel> {

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

    override func bindRoutes() {
        super.bindRoutes()

        inputsRelay.showJobDetails
            .map { RouteModel.showJobDetails($0) }
            .sink { [weak self] in self?.trigger($0) }
            .store(in: &subscriptionsStore)
    }

}

// MARK: - JobsListViewModelType

extension JobsListViewModel: JobsListViewModelType {

    var inputs: JobsListViewModelTypeInputs { inputsRelay }
    var outputs: JobsListViewModelTypeOutputs { outputsRelay }

}
