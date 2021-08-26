import CombineExt
import Foundation

extension JobsListViewModel {

    final class InputsRelay: JobsListViewModelTypeInputs {

        let showJobDetails = ShowJobDetailsSubject()

        let currentPageRelay = CurrentValueRelay<Int>(1)
        let reloadDataRelay = PassthroughRelay<Void>()

        func increasePage() {
            currentPageRelay.accept(currentPageRelay.value + 1)
        }

        func reloadData() {
            reloadDataRelay.accept()
        }

    }

}
