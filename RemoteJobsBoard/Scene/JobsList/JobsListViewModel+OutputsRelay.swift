import Combine
import CombineExt
import Foundation

extension JobsListViewModel {

    final class OutputsRelay {

        let jobsRelay = CurrentValueRelay<[Job]>([])
        let jobsLoadingFinishedRelay = PassthroughRelay<Void>()

        let allJobs = CurrentValueRelay<[Job]>([])

    }

}

// MARK: - JobsListViewModelTypeOutputs

extension JobsListViewModel.OutputsRelay: JobsListViewModelTypeOutputs {

    var jobs: JobsSubject { jobsRelay.eraseToAnyPublisher() }
    var jobsLoadingFinished: JobsLoadingFinishedSubject { jobsLoadingFinishedRelay.eraseToAnyPublisher() }

}
