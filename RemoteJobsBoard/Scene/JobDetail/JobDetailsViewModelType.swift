import Combine
import CombineExt
import Foundation

protocol JobDetailsViewModelType: AnyObject {

    var inputs: JobDetailViewModelTypeInputs { get }
    var outputs: JobDetailViewModelTypeOutputs { get }

    func bind()

}

// MARK: - Inputs

protocol JobDetailViewModelTypeInputs: AnyObject {

    typealias SelectedLinkSubject = PassthroughRelay<URL>
    typealias SelectedPhoneNumberSubject = PassthroughRelay<String>

    var selectedLink: SelectedLinkSubject { get }
    var selectedPhoneNumber: SelectedPhoneNumberSubject { get }

}

// MARK: - Outputs

protocol JobDetailViewModelTypeOutputs: AnyObject {

    typealias JobSubject = AnyPublisher<Job, Never>

    var job: JobSubject { get }

}
