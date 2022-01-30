import Foundation
import Combine
import CombineExtensions

final class JobCategoryJobsListViewModel: BaseViewModel<RootCoordinator.RouteModel>, JobCategoryJobsListViewModelTypeInputs, JobsListSearchResultsViewModelTypeInputs {

	// MARK: - Properties

	private let categoryRelay: Job.Category
	private let allJobsRelay: CurrentValueRelay<[Job]>

	private let currentPageRelay = CurrentValueRelay<Int>(1)
	private let currentSearchPageRelay = CurrentValueRelay<Int>(1)

	private let bindQueue = DispatchQueue(
		label: String(describing: JobCategoryJobsListViewModel.self) + "BindQueue",
		qos: .userInteractive
	)

	// MARK: - Properties - JobCategoryJobsListViewModelTypeInputs

	let showJobDetails = ShowJobDetailsSubject()
	let showNextPage = NextPageSubject()

	// MARK: - Properties - JobsListSearchResultsViewModelTypeInputs

	let searchText = SearchTextSubject(nil)
	let showNextSearchPage = NextPageSubject()

	// MARK: - Initialization

	init(category: Job.Category, jobs: [Job], router: Router, services: ServicesContainer) {
		allJobsRelay = CurrentValueRelay(jobs)
		categoryRelay = category

		super.init(router: router, services: services)
	}

	// MARK: - Base Class

	override func bind() {
		super.bind()

		subscriptions {
			showNextPage
				.withLatestFrom(currentPageRelay, resultSelector: Self.nextPageMap)
				.subscribe(currentPageRelay)
		}
	}

	override func bindRoutes() {
		super.bindRoutes()

		showJobDetails.map { RouteModel.showJobDetails($0) }
		.sinkValue { [weak self] in self?.trigger($0) }
		.store(in: subscriptions)
	}

}

// MARK: - Private Methods

private extension JobCategoryJobsListViewModel {

	static func nextPageMap(_ trigger: Void, _ currentPage: Int) -> Int {
		currentPage + 1
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

}

// MARK: - JobCategoryJobsListViewModelType

extension JobCategoryJobsListViewModel: JobCategoryJobsListViewModelType {

	var inputs: JobCategoryJobsListViewModelTypeInputs { self }
	var outputs: JobCategoryJobsListViewModelTypeOutputs { self }

}

// MARK: - JobCategoryJobsListViewModelTypeOutputs

extension JobCategoryJobsListViewModel: JobCategoryJobsListViewModelTypeOutputs {

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

	var categoryName: String {
		categoryRelay.categoryCellCategoryName
	}

}

// MARK: - JobsListSearchResultsViewModelType

extension JobCategoryJobsListViewModel: JobsListSearchResultsViewModelType {

	var searchResultsInputs: JobsListSearchResultsViewModelTypeInputs { self }
	var searchResultsOutputs: JobsListSearchResultsViewModelTypeOutputs { self }

}

// MARK: - JobsListSearchResultsViewModelTypeOutputs

extension JobCategoryJobsListViewModel: JobsListSearchResultsViewModelTypeOutputs {

	var searchResultJobs: JobsSubject {
		Publishers.CombineLatest3(
			allJobsRelay,
			searchText,
			currentSearchPageRelay
		)
		.debounce(for: 0.1, scheduler: RunLoop.main)
		.map(Self.searchResultJobs)
		.removeDuplicates()
		.eraseToAnyPublisher()
	}

}

// MARK: - Constants

private extension JobCategoryJobsListViewModel {

	enum Constant {

		static let itemsPerPage = 20
	}

}
