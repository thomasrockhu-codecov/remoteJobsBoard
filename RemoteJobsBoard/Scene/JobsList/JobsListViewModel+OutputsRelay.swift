import Combine
import CombineExt
import Foundation

extension JobsListViewModel {

    final class OutputsRelay {

        let jobsRelay = CurrentValueRelay<[Job]>([])

    }

}

// MARK: - JobsListViewModelTypeOutputs

extension JobsListViewModel.OutputsRelay: JobsListViewModelTypeOutputs {

    var jobs: JobsSubject { jobsRelay.eraseToAnyPublisher() }

}
