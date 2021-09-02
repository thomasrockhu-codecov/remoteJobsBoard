import Combine
import Foundation

final class JobDetailsViewModel: BaseViewModel<RootCoordinator.RouteModel> {

    // MARK: - Properties

    private let outputsRelay: OutputsRelay

    private let inputsRelay = InputsRelay()

    // MARK: - Initialization

    init(job: Job, router: Router, services: ServicesContainer) {
        outputsRelay = OutputsRelay(job: job)

        super.init(router: router, services: services)
    }

    // MARK: - Base Class

    override func bindRoutes() {
        super.bindRoutes()

        let selectedLink = inputs.selectedLink
            .map { RouteModel.webPage($0) }
        let selectedPhoneNumber = inputs.selectedPhoneNumber
            .map { RouteModel.phoneNumber($0) }
        let applyToJob = inputsRelay.applyToJob
            .withLatestFrom(outputsRelay.job) {
                RouteModel.webPage($1.url)
            }

        Publishers.Merge3(selectedLink, selectedPhoneNumber, applyToJob)
            .sink { [weak self] in self?.trigger($0) }
            .store(in: &subscriptionsStore)
    }

}

// MARK: - JobsListViewModelType

extension JobDetailsViewModel: JobDetailsViewModelType {

    var inputs: JobDetailViewModelTypeInputs { inputsRelay }
    var outputs: JobDetailViewModelTypeOutputs { outputsRelay }

}
