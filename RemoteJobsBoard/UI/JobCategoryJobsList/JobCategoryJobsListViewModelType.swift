import Combine
import Foundation

protocol JobCategoryJobsListViewModelType: AnyObject {

	var inputs: JobCategoryJobsListViewModelTypeInputs { get }
	var outputs: JobCategoryJobsListViewModelTypeOutputs { get }

	func bind()

}

// MARK: - Inputs

protocol JobCategoryJobsListViewModelTypeInputs: AnyObject {

	typealias ShowJobDetailsSubject = JobsListViewModelTypeInputs.ShowJobDetailsSubject
	typealias NextPageSubject = JobsListViewModelTypeInputs.NextPageSubject

	var showJobDetails: ShowJobDetailsSubject { get }
	var showNextPage: NextPageSubject { get }

}

// MARK: - Outputs

protocol JobCategoryJobsListViewModelTypeOutputs: AnyObject {

	typealias JobsSubject = JobsListViewModelTypeOutputs.JobsSubject

	var jobs: JobsSubject { get }
	var categoryName: String { get }

}
