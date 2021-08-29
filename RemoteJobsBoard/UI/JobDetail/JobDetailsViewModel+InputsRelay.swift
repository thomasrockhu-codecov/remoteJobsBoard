import Foundation

extension JobDetailsViewModel {

    final class InputsRelay: JobDetailViewModelTypeInputs {

        let selectedLink = SelectedLinkSubject()
        let selectedPhoneNumber = SelectedPhoneNumberSubject()
        let applyToJob = ApplyToJobSubject()

    }
}
