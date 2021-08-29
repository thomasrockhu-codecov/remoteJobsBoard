import Combine
import Foundation

final class JobsListViewModel: BaseViewModel<JobsListCoordinator.RouteModel> {

    // MARK: - Properties

    private let api: APIServiceType

    private let inputsRelay = InputsRelay()
    private let outputsRelay = OutputsRelay()
    private let combineLatestQueue = DispatchQueue(label: "JobsListViewModelCLQueue", qos: .userInitiated)

    // MARK: - Initialization

    override init(router: Router, services: ServicesContainer) {
        api = services.api

        super.init(router: router, services: services)
    }

    // MARK: - Base Class

    override func bind() {
        super.bind()

        let searchText = inputsRelay.searchText.share(replay: 1)
        let allJobs = outputsRelay.allJobs.share(replay: 1)

        inputsRelay.reloadDataRelay
            .prepend(())
            .flatMap { [weak self] in
                self?.api.getJobs().catch(errorHandler: self?.errorHandler) ?? Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] jobs in
                guard let self = self else { return }
                self.outputsRelay.jobsLoadingFinishedRelay.accept()
                self.inputsRelay.currentPageRelay.accept(1)
                self.outputsRelay.allJobs.accept(jobs)
            }
            .store(in: &subscriptionsStore)

        searchText
            .map { _ in 1 }
            .subscribe(inputsRelay.currentSearchPageRelay)
            .store(in: &subscriptionsStore)

        Publishers.CombineLatest3(searchText, allJobs, inputsRelay.currentSearchPageRelay)
            .debounce(for: 0.1, scheduler: combineLatestQueue)
            .map { searchText, allJobs, page -> (Int, [Job]) in
                guard let searchText = searchText?.orNil else { return (page, allJobs) }
                let filtered = allJobs.filter {
                    $0.companyName.localizedCaseInsensitiveContains(searchText)
                        || $0.title.localizedCaseInsensitiveContains(searchText)
                }
                return (page, filtered)
            }
            .map { Array($1.prefix($0 * Constant.itemsPerPage)) }
            .subscribe(outputsRelay.searchResultJobsRelay)
            .store(in: &subscriptionsStore)

        Publishers.CombineLatest(inputsRelay.currentPageRelay, allJobs)
            .debounce(for: 0.1, scheduler: combineLatestQueue)
            .map { Array($1.prefix($0 * Constant.itemsPerPage)) }
            .subscribe(outputsRelay.jobsRelay)
            .store(in: &subscriptionsStore)
    }

    override func bindRoutes() {
        super.bindRoutes()

        inputsRelay.showJobDetails
            .map { RouteModel.showJobDetails($0) }
            .sink { [weak self] in self?.trigger($0) }
            .store(in: &subscriptionsStore)
    }

}

// MARK: - JobsListViewModelType

extension JobsListViewModel: JobsListViewModelType {

    var inputs: JobsListViewModelTypeInputs { inputsRelay }
    var outputs: JobsListViewModelTypeOutputs { outputsRelay }

}

// MARK: - Constants

private extension JobsListViewModel {

    enum Constant {

        static let itemsPerPage = 20
    }

}
