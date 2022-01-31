import Combine
import CombineExtensions
import Foundation

protocol JobsSearchViewModelType: BaseViewModelType {

	var searchResultsInput: JobsSearchViewModelInput { get }
	var searchResultsOutput: JobsSearchViewModelOutput { get }

}

extension JobsSearchViewModelType where Self: JobsSearchViewModelInput {

	var searchResultsInput: JobsSearchViewModelInput { self }

}

extension JobsSearchViewModelType where Self: JobsSearchViewModelOutput {

	var searchResultsOutput: JobsSearchViewModelOutput { self }

}

// MARK: - Inputs

protocol JobsSearchViewModelInput: AnyObject {

	typealias ShowJobDetailsSubject = PassthroughRelay<Job>
	typealias NextPageSubject = PassthroughRelay<Void>
	typealias SearchTextSubject = CurrentValueRelay<String?>

	var showJobDetails: ShowJobDetailsSubject { get }
	var showNextSearchPage: NextPageSubject { get }
	var searchText: SearchTextSubject { get }

}

// MARK: - Outputs

protocol JobsSearchViewModelOutput: AnyObject {

	typealias SearchResultJobsSubject = AnyPublisher<[Job], Never>

	var searchResultJobs: SearchResultJobsSubject { get }

}
