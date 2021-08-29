import Combine
import CombineExt
import Foundation

extension JobsListViewModel {

    final class OutputsRelay {

        let jobsRelay = CurrentValueRelay<[Job]>([])
        let jobsLoadingFinishedRelay = PassthroughRelay<Void>()
        let searchResultJobsRelay = CurrentValueRelay<[Job]>([])

        let allJobs = CurrentValueRelay<[Job]>([])

    }

}

// MARK: - JobsListViewModelTypeOutputs

extension JobsListViewModel.OutputsRelay: JobsListViewModelTypeOutputs {

    var jobs: JobsSubject { jobsRelay.eraseToAnyPublisher() }
    var searchResultJobs: JobsSubject { searchResultJobsRelay.eraseToAnyPublisher() }
    var jobsLoadingFinished: JobsLoadingFinishedSubject { jobsLoadingFinishedRelay.eraseToAnyPublisher() }

}
