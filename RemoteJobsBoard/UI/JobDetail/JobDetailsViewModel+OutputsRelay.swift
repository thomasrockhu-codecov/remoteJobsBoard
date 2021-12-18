import Combine
import CombineExtensions
import Foundation

extension JobDetailsViewModel {
	
	final class OutputsRelay {
		
		private let jobRelay: CurrentValueRelay<Job>
		
		init(job: Job) {
			jobRelay = CurrentValueRelay(job)
		}
		
	}
	
}

// MARK: - JobDetailViewModelTypeOutputs

extension JobDetailsViewModel.OutputsRelay: JobDetailViewModelTypeOutputs {
	
	var job: JobSubject { jobRelay.eraseToAnyPublisher() }
	
}
