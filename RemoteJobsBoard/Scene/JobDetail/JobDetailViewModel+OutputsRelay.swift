import Combine
import CombineExt
import Foundation

extension JobDetailViewModel {

    final class OutputsRelay {

        private let jobRelay: CurrentValueRelay<Job>

        init(job: Job) {
            jobRelay = CurrentValueRelay(job)
        }

    }

}

// MARK: - JobDetailViewModelTypeOutputs

extension JobDetailViewModel.OutputsRelay: JobDetailViewModelTypeOutputs {

    var job: JobSubject { jobRelay.eraseToAnyPublisher() }

}
