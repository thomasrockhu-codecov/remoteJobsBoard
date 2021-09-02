import Combine
import CombineExt
import Foundation

final class JobsListViewModel: BaseViewModel<RootCoordinator.RouteModel> {

    // MARK: - Properties

    private let api: APIServiceType

    private let showJobDetailsRelay = ShowJobDetailsSubject()
    private let searchTextRelay = SearchTextSubject(nil)
    private let reloadDataRelay = ReloadDataSubject()
    private let showNextPageRelay = NextPageSubject()
    private let showNextSearchPageRelay = NextPageSubject()
    private let currentPageRelay = CurrentValueRelay<Int>(1)
    private let currentSearchPageRelay = CurrentValueRelay<Int>(1)
    private let allJobsRelay = CurrentValueRelay<[Job]>([])
    private let jobsLoadingFinishedRelay = PassthroughRelay<Void>()

    private let bindQueue = DispatchQueue(label: "JLVM_bindQueue", qos: .userInteractive)

    // MARK: - Initialization

    override init(router: Router, services: ServicesContainer) {
        api = services.api

        super.init(router: router, services: services)
    }

    // MARK: - Base Class

    override func bind() {
        super.bind()

        reloadDataRelay
            .prepend(())
            .flatMap { [weak self] in
                self?.api.getJobs().catch(errorHandler: self?.errorHandler) ?? Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] jobs in
                guard let self = self else { return }
                self.jobsLoadingFinishedRelay.accept()
                self.currentPageRelay.accept(1)
                self.allJobsRelay.accept(jobs)
            }
            .store(in: &subscriptionsStore)

        searchText
            .map { _ in 1 }
            .subscribe(currentSearchPageRelay)
            .store(in: &subscriptionsStore)

        showNextPageRelay
            .withLatestFrom(currentPageRelay, resultSelector: Self.nextPageMap)
            .subscribe(currentPageRelay)
            .store(in: &subscriptionsStore)
        showNextSearchPageRelay
            .withLatestFrom(currentSearchPageRelay, resultSelector: Self.nextPageMap)
            .subscribe(currentSearchPageRelay)
            .store(in: &subscriptionsStore)
    }

    override func bindRoutes() {
        super.bindRoutes()

        showJobDetails
            .map { RouteModel.showJobDetails($0) }
            .sink { [weak self] in self?.trigger($0) }
            .store(in: &subscriptionsStore)
    }

}

// MARK: - Private Methods

private extension JobsListViewModel {

    static func nextPageMap(_ trigger: Void, _ currentPage: Int) -> Int {
        currentPage + 1
    }

}

// MARK: - JobsListViewModelType

extension JobsListViewModel: JobsListViewModelType {

    var inputs: JobsListViewModelTypeInputs { self }
    var outputs: JobsListViewModelTypeOutputs { self }

}

// MARK: - JobsListViewModelTypeInputs

extension JobsListViewModel: JobsListViewModelTypeInputs {

    var showJobDetails: ShowJobDetailsSubject { showJobDetailsRelay }
    var searchText: SearchTextSubject { searchTextRelay }
    var reloadData: ReloadDataSubject { reloadDataRelay }
    var showNextPage: NextPageSubject { showNextPageRelay }
    var showNextSearchPage: NextPageSubject { showNextSearchPageRelay }

}

// MARK: - JobsListViewModelTypeOutputs

extension JobsListViewModel: JobsListViewModelTypeOutputs {

    var jobsLoadingFinished: JobsLoadingFinishedSubject {
        jobsLoadingFinishedRelay.eraseToAnyPublisher()
    }

    var jobs: JobsSubject {
        Publishers.CombineLatest(
            currentPageRelay,
            allJobsRelay
        )
        .debounce(for: 0.1, scheduler: bindQueue)
        .map { Array($1.prefix($0 * Constant.itemsPerPage)) }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }

    var searchResultJobs: JobsSubject {
        Publishers.CombineLatest3(
            searchText,
            allJobsRelay,
            currentSearchPageRelay
        )
        .debounce(for: 0.1, scheduler: bindQueue)
        .map { searchText, allJobs, page -> [Job] in
            guard let searchText = searchText?.orNil else { return [] }
            let filtered = allJobs
                .filter {
                    $0.companyName.localizedCaseInsensitiveContains(searchText)
                        || $0.title.localizedCaseInsensitiveContains(searchText)
                }
                .prefix(page * Constant.itemsPerPage)
            return Array(filtered)
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }

}

// MARK: - Constants

private extension JobsListViewModel {

    enum Constant {

        static let itemsPerPage = 20
    }

}
