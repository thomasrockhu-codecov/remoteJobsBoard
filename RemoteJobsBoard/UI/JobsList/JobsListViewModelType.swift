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
    typealias ReloadDataSubject = PassthroughRelay<Void>
    typealias NextPageSubject = PassthroughRelay<Void>

    var showJobDetails: ShowJobDetailsSubject { get }
    var searchText: SearchTextSubject { get }
    var reloadData: ReloadDataSubject { get }
    var showNextPage: NextPageSubject { get }
    var showNextSearchPage: NextPageSubject { get }

}

// MARK: - Outputs

protocol JobsListViewModelTypeOutputs: AnyObject {

    typealias JobsSubject = AnyPublisher<[Job], Never>
    typealias JobsLoadingFinishedSubject = AnyPublisher<Void, Never>

    var jobs: JobsSubject { get }
    var searchResultJobs: JobsSubject { get }
    var jobsLoadingFinished: JobsLoadingFinishedSubject { get }

}
