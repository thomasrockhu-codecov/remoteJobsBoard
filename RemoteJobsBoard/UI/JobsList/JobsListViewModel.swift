import Combine
import CombineExt
import Foundation

final class JobsListViewModel: BaseViewModel<JobsListCoordinator.RouteModel> {

    // MARK: - Properties

    private let api: APIServiceType

    private let showJobDetailsRelay = ShowJobDetailsSubject()
    private let searchTextRelay = SearchTextSubject(nil)
    private let currentPageRelay = CurrentValueRelay<Int>(1)
    private let currentSearchPageRelay = CurrentValueRelay<Int>(1)
    private let reloadDataRelay = PassthroughRelay<Void>()
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
    }

    override func bindRoutes() {
        super.bindRoutes()

        showJobDetails
            .map { RouteModel.showJobDetails($0) }
            .sink { [weak self] in self?.trigger($0) }
            .store(in: &subscriptionsStore)
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

// MARK: - JobsListViewModelTypeOutputs

extension JobsListViewModel: JobsListViewModelTypeOutputs {

    var jobsLoadingFinished: JobsLoadingFinishedSubject {
        jobsLoadingFinishedRelay.eraseToAnyPublisher()
    }

    var jobs: JobsSubject {
        Publishers.CombineLatest(
            currentPageRelay.removeDuplicates(),
            allJobsRelay.removeDuplicates()
        )
        .debounce(for: 0.1, scheduler: bindQueue)
        .map { Array($1.prefix($0 * Constant.itemsPerPage)) }
        .eraseToAnyPublisher()
    }

    var searchResultJobs: JobsSubject {
        Publishers.CombineLatest3(
            searchText.removeDuplicates(),
            allJobsRelay.removeDuplicates(),
            currentSearchPageRelay.removeDuplicates()
        )
        .debounce(for: 0.1, scheduler: bindQueue)
        .map { searchText, allJobs, page -> [Job] in
            guard let searchText = searchText?.orNil else { return allJobs }
            let filtered = allJobs
                .filter {
                    $0.companyName.localizedCaseInsensitiveContains(searchText)
                        || $0.title.localizedCaseInsensitiveContains(searchText)
                }
                .prefix(page * Constant.itemsPerPage)
            return Array(filtered)
        }
        .eraseToAnyPublisher()
    }

}

// MARK: - Constants

private extension JobsListViewModel {

    enum Constant {

        static let itemsPerPage = 20
    }

}
