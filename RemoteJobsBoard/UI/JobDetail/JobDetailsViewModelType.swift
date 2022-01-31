import Combine
import CombineExtensions
import Foundation

protocol JobDetailsViewModelType: BaseViewModelType {

	var input: JobDetailViewModelInput { get }
	var output: JobDetailViewModelOutput { get }

}

extension JobDetailsViewModelType where Self: JobDetailViewModelInput {

	var input: JobDetailViewModelInput { self }

}

extension JobDetailsViewModelType where Self: JobDetailViewModelOutput {

	var output: JobDetailViewModelOutput { self }

}

// MARK: - Inputs

protocol JobDetailViewModelInput: AnyObject {

	typealias SelectedLinkSubject = PassthroughRelay<URL>
	typealias SelectedPhoneNumberSubject = PassthroughRelay<String>
	typealias ApplyToJobSubject = PassthroughRelay<Void>

	var selectedLink: SelectedLinkSubject { get }
	var selectedPhoneNumber: SelectedPhoneNumberSubject { get }
	var applyToJob: ApplyToJobSubject { get }

}

// MARK: - Outputs

protocol JobDetailViewModelOutput: AnyObject {

	typealias JobSubject = AnyPublisher<Job, Never>

	var job: JobSubject { get }

}
