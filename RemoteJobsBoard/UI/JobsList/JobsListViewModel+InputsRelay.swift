import CombineExt
import Foundation

extension JobsListViewModel {

    final class InputsRelay: JobsListViewModelTypeInputs {

        let showJobDetails = ShowJobDetailsSubject()
        let searchText = SearchTextSubject(nil)

        let currentPageRelay = CurrentValueRelay<Int>(1)
        let currentSearchPageRelay = CurrentValueRelay<Int>(1)
        let reloadDataRelay = PassthroughRelay<Void>()

        func increasePage() {
            currentPageRelay.accept(currentPageRelay.value + 1)
        }
        func increaseSearchPage() {
            currentSearchPageRelay.accept(currentSearchPageRelay.value + 1)
        }

        func reloadData() {
            reloadDataRelay.accept()
        }

    }

}
