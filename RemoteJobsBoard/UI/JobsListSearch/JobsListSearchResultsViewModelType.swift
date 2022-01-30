import Combine
import CombineExtensions
import Foundation

protocol JobsListSearchResultsViewModelType: AnyObject {

	var searchResultsInputs: JobsListSearchResultsViewModelTypeInputs { get }
	var searchResultsOutputs: JobsListSearchResultsViewModelTypeOutputs { get }

	func bind()

}

// MARK: - Inputs

protocol JobsListSearchResultsViewModelTypeInputs: AnyObject {

	typealias ShowJobDetailsSubject = PassthroughRelay<Job>
	typealias NextPageSubject = PassthroughRelay<Void>
	typealias SearchTextSubject = CurrentValueRelay<String?>

	var showJobDetails: ShowJobDetailsSubject { get }
	var showNextSearchPage: NextPageSubject { get }
	var searchText: SearchTextSubject { get }

}

// MARK: - Outputs

protocol JobsListSearchResultsViewModelTypeOutputs: AnyObject {

	typealias JobsSubject = AnyPublisher<[Job], Never>

	var searchResultJobs: JobsSubject { get }

}
