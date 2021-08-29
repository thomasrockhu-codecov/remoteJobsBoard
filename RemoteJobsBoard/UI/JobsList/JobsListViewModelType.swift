import Combine
import CombineExt
import Foundation

protocol JobsListViewModelType: AnyObject {

    var inputs: JobsListViewModelTypeInputs { get }
    var outputs: JobsListViewModelTypeOutputs { get }

    func bind()

}

// MARK: - Inputs

protocol JobsListViewModelTypeInputs: AnyObject {

    typealias ShowJobDetailsSubject = PassthroughRelay<Job>
    typealias SearchTextSubject = CurrentValueRelay<String?>

    var showJobDetails: ShowJobDetailsSubject { get }
    var searchText: SearchTextSubject { get }

    func increasePage()
    func increaseSearchPage()
    func reloadData()

}

// MARK: - Outputs

protocol JobsListViewModelTypeOutputs: AnyObject {

    typealias JobsSubject = AnyPublisher<[Job], Never>
    typealias JobsLoadingFinishedSubject = AnyPublisher<Void, Never>

    var jobs: JobsSubject { get }
    var searchResultJobs: JobsSubject { get }
    var jobsLoadingFinished: JobsLoadingFinishedSubject { get }

}
