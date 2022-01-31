import Combine
import CombineExtensions
import Foundation

protocol JobsListViewModelType: BaseViewModelType {
	
	var input: JobsListViewModelInput { get }
	var output: JobsListViewModelOutput { get }
	
}

extension JobsListViewModelType where Self: JobsListViewModelInput {

	var input: JobsListViewModelInput { self }

}

extension JobsListViewModelType where Self: JobsListViewModelOutput {

	var output: JobsListViewModelOutput { self }

}

// MARK: - Inputs

protocol JobsListViewModelInput: AnyObject {
	
	typealias ShowJobDetailsSubject = PassthroughRelay<Job>
	typealias ReloadDataSubject = PassthroughRelay<Void>
	typealias ShowCategoryJobsSubject = PassthroughRelay<Job.Category>
	typealias NextPageSubject = PassthroughRelay<Void>
	
	var showJobDetails: ShowJobDetailsSubject { get }
	var showCategoryJobs: ShowCategoryJobsSubject { get }
	var reloadData: ReloadDataSubject { get }
	var showNextPage: NextPageSubject { get }
	
}

// MARK: - Outputs

protocol JobsListViewModelOutput: AnyObject {
	
	typealias JobsSubject = AnyPublisher<[Job], Never>
	typealias JobCategoriesSubject = AnyPublisher<[Job.Category], Never>
	typealias JobsLoadingFinishedSubject = AnyPublisher<Void, Never>
	
	var jobs: JobsSubject { get }
	var jobCategories: JobCategoriesSubject { get }
	var jobsLoadingFinished: JobsLoadingFinishedSubject { get }
	
}
