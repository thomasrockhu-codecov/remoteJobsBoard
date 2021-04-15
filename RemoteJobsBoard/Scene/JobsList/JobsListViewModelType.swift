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

    var showJobDetails: ShowJobDetailsSubject { get }

}

// MARK: - Outputs

protocol JobsListViewModelTypeOutputs: AnyObject {

    typealias JobsSubject = AnyPublisher<[Job], Never>

    var jobs: JobsSubject { get }

}
