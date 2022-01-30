import Combine
import CombineExtensions
import Foundation

final class JobsListViewModel: BaseViewModel<RootCoordinator.RouteModel>, JobsListViewModelTypeInputs, JobsListSearchResultsViewModelTypeInputs {

	// MARK: - Properties

	private let api: APIServiceType

	private let currentPageRelay = CurrentValueRelay<Int>(1)
	private let currentSearchPageRelay = CurrentValueRelay<Int>(1)
	private let allJobsRelay = CurrentValueRelay<[Job]>([])
	private let jobsLoadingFinishedRelay = PassthroughRelay<Void>()

	private let bindQueue = DispatchQueue(
		label: String(describing: JobsListViewModel.self) + "BindQueue",
		qos: .userInteractive
	)

	// MARK: - Properties - JobsListViewModelTypeInputs

	let showJobDetails = ShowJobDetailsSubject()
	let reloadData = ReloadDataSubject()
	let showNextPage = NextPageSubject()
	let showCategoryJobs = ShowCategoryJobsSubject()

	// MARK: - Properties - JobsListSearchResultsViewModelTypeInputs

	let showNextSearchPage = NextPageSubject()
	let searchText = SearchTextSubject(nil)

	// MARK: - Initialization

	override init(router: Router, services: ServicesContainer) {
		api = services.api

		super.init(router: router, services: services)
	}

	// MARK: - Base Class

	override func bind() {
		super.bind()

		subscriptions {
			reloadData
				.prepend(())
				.flatMap { [weak self] in
					self?.api.getJobs().catch(errorHandler: self?.errorHandler) ?? Empty().eraseToAnyPublisher()
				}
				.sinkValue { [weak self] in self?.handleDataReload(with: $0) }
			searchText
				.map { _ in 1 }
				.subscribe(currentSearchPageRelay)
			showNextPage
				.withLatestFrom(currentPageRelay, resultSelector: Self.nextPageMap)
				.subscribe(currentPageRelay)
			showNextSearchPage
				.withLatestFrom(currentSearchPageRelay, resultSelector: Self.nextPageMap)
				.subscribe(currentSearchPageRelay)
		}
	}

	override func bindRoutes() {
		super.bindRoutes()

		Publishers.Merge(
			showJobDetails.map { RouteModel.showJobDetails($0) },
			showCategoryJobs.withLatestFrom(allJobsRelay, resultSelector: Self.showCategoryJobsRoute)
		)
		.sinkValue { [weak self] in self?.trigger($0) }
		.store(in: subscriptions)
	}

}

// MARK: - Private Methods

private extension JobsListViewModel {

	static func showCategoryJobsRoute(for category: Job.Category, with jobs: [Job]) -> RouteModel {
		let jobs = jobs.filter { $0.category == category }
		return .showCategoryJobs(category: category, jobs: jobs)
	}

	static func nextPageMap(_ trigger: Void, _ currentPage: Int) -> Int {
		currentPage + 1
	}

	static func jobCategories(from jobs: [Job]) -> [Job.Category] {
		Array(Set(jobs.map({ $0.category }))).sorted()
	}

	static func searchResultJobs(from allJobs: [Job], filteredBy searchText: String?, page: Int) -> [Job] {
		guard let searchText = searchText?.orNil else { return [] }
		let filtered = allJobs
			.filter {
				$0.companyName.localizedCaseInsensitiveContains(searchText)
				|| $0.title.localizedCaseInsensitiveContains(searchText)
			}
			.prefix(page * Constant.itemsPerPage)
		return Array(filtered)
	}

	func handleDataReload(with jobs: [Job]) {
		jobsLoadingFinishedRelay.accept()
		currentPageRelay.accept(1)
		allJobsRelay.accept(jobs)
	}

}

// MARK: - JobsListViewModelType

extension JobsListViewModel: JobsListViewModelType {

	var inputs: JobsListViewModelTypeInputs { self }
	var outputs: JobsListViewModelTypeOutputs { self }

}

// MARK: - JobsListViewModelTypeOutputs

extension JobsListViewModel: JobsListViewModelTypeOutputs {

	var jobsLoadingFinished: JobsLoadingFinishedSubject {
		jobsLoadingFinishedRelay.eraseToAnyPublisher()
	}

	var jobCategories: JobCategoriesSubject {
		jobs
			.map(Self.jobCategories)
			.removeDuplicates()
			.eraseToAnyPublisher()
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

}

// MARK: - JobsListSearchResultsViewModelType

extension JobsListViewModel: JobsListSearchResultsViewModelType {

	var searchResultsInputs: JobsListSearchResultsViewModelTypeInputs { self }
	var searchResultsOutputs: JobsListSearchResultsViewModelTypeOutputs { self }

}

// MARK: - JobsListSearchResultsViewModelTypeOutputs

extension JobsListViewModel: JobsListSearchResultsViewModelTypeOutputs {

	var searchResultJobs: JobsSubject {
		Publishers.CombineLatest3(
			allJobsRelay,
			searchText,
			currentSearchPageRelay
		)
		.debounce(for: 0.1, scheduler: bindQueue)
		.map(Self.searchResultJobs)
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
