import Combine
import CombineExtensions
import Foundation

protocol JobsListViewModelType: AnyObject {
	
	var inputs: JobsListViewModelTypeInputs { get }
	var outputs: JobsListViewModelTypeOutputs { get }
	
	func bind()
	
}

// MARK: - Inputs

protocol JobsListViewModelTypeInputs: AnyObject {
	
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

protocol JobsListViewModelTypeOutputs: AnyObject {
	
	typealias JobsSubject = AnyPublisher<[Job], Never>
	typealias JobCategoriesSubject = AnyPublisher<[Job.Category], Never>
	typealias JobsLoadingFinishedSubject = AnyPublisher<Void, Never>
	
	var jobs: JobsSubject { get }
	var jobCategories: JobCategoriesSubject { get }
	var jobsLoadingFinished: JobsLoadingFinishedSubject { get }
	
}
