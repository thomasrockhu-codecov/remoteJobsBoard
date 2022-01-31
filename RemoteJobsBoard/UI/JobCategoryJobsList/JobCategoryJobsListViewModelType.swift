import Combine
import Foundation

protocol JobCategoryJobsListViewModelType: BaseViewModelType {

	var input: JobCategoryJobsListViewModelInput { get }
	var output: JobCategoryJobsListViewModelOutput { get }

}

extension JobCategoryJobsListViewModelType where Self: JobCategoryJobsListViewModelInput {

	var input: JobCategoryJobsListViewModelInput { self }

}

extension JobCategoryJobsListViewModelType where Self: JobCategoryJobsListViewModelOutput {

	var output: JobCategoryJobsListViewModelOutput { self }

}

// MARK: - Inputs

protocol JobCategoryJobsListViewModelInput: AnyObject {

	typealias ShowJobDetailsSubject = JobsListViewModelInput.ShowJobDetailsSubject
	typealias NextPageSubject = JobsListViewModelInput.NextPageSubject

	var showJobDetails: ShowJobDetailsSubject { get }
	var showNextPage: NextPageSubject { get }

}

// MARK: - Outputs

protocol JobCategoryJobsListViewModelOutput: AnyObject {

	typealias JobsSubject = JobsListViewModelOutput.JobsSubject

	var jobs: JobsSubject { get }
	var categoryName: String { get }

}
