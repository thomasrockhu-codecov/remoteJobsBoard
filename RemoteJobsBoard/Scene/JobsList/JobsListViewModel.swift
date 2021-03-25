import Combine
import Foundation

final class JobsListViewModel: BaseViewModel<JobsListCoordinator.RouteModel> {

    // MARK: - Properties

    private let inputsRelay = InputsRelay()
    private let outputsRelay = OutputsRelay()

}

// MARK: - JobsListViewModelType

extension JobsListViewModel: JobsListViewModelType {

    var inputs: JobsListViewModelTypeInputs { inputsRelay }
    var outputs: JobsListViewModelTypeOutputs { outputsRelay }

}
