import Combine
import CombineExtensions
import Foundation

extension JobDetails {

	final class ViewModel: BaseViewModel<RootCoordinator.RouteModel>, JobDetailsViewModelType, JobDetailViewModelInput {

		// MARK: - Properties

		private let jobRelay: CurrentValueRelay<Job>

		// MARK: - Properties - JobDetailViewModelInput

		let selectedLink = SelectedLinkSubject()
		let selectedPhoneNumber = SelectedPhoneNumberSubject()
		let applyToJob = ApplyToJobSubject()

		// MARK: - Initialization

		init(job: Job, router: Router, services: ServicesContainer) {
			jobRelay = CurrentValueRelay(job)

			super.init(router: router, services: services)
		}

		// MARK: - Base Class

		override func bindRoutes() {
			super.bindRoutes()

			Publishers.Merge3(
				input.selectedLink.map { RouteModel.webPage($0) },
				input.selectedPhoneNumber.map { RouteModel.phoneNumber($0) },
				applyToJob.withLatestFrom(jobRelay) { RouteModel.webPage($1.url) }
			)
			.sinkValue { [weak self] in self?.trigger($0) }
			.store(in: cancellable)
		}

	}

}

// MARK: - JobDetailViewModelOutput

extension JobDetails.ViewModel: JobDetailViewModelOutput {

	var job: JobSubject { jobRelay.eraseToAnyPublisher() }
	
}
