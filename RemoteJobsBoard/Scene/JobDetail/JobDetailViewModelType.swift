import Combine
import CombineExt
import Foundation

protocol JobDetailViewModelType: AnyObject {

    var inputs: JobDetailViewModelTypeInputs { get }
    var outputs: JobDetailViewModelTypeOutputs { get }

    func bind()

}

// MARK: - Inputs

protocol JobDetailViewModelTypeInputs: AnyObject {}

// MARK: - Outputs

protocol JobDetailViewModelTypeOutputs: AnyObject {

    typealias JobSubject = AnyPublisher<Job, Never>

    var job: JobSubject { get }

}
