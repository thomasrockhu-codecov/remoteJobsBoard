import Foundation
import Combine
import CombineExtensions

extension JobCategoryJobsList {

	final class ViewModel: BaseViewModel<RootCoordinator.RouteModel>, JobCategoryJobsListViewModelType, JobsSearchViewModelType, JobCategoryJobsListViewModelInput, JobsSearchViewModelInput {

		// MARK: - Properties

		private let categoryRelay: Job.Category
		private let allJobsRelay: CurrentValueRelay<[Job]>

		private let currentPageRelay = CurrentValueRelay<Int>(1)
		private let currentSearchPageRelay = CurrentValueRelay<Int>(1)

		// MARK: - Properties - JobCategoryJobsListViewModelInput

		let showJobDetails = ShowJobDetailsSubject()
		let showNextPage = NextPageSubject()

		// MARK: - Properties - JobsSearchViewModelInput

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

			cancellable {
				showNextPage
					.withLatestFrom(currentPageRelay, resultSelector: Self.nextPageMap)
					.subscribe(currentPageRelay)
			}
		}

		override func bindRoutes() {
			super.bindRoutes()

			showJobDetails
				.map { RouteModel.showJobDetails($0) }
				.sinkValue { [weak self] in self?.trigger($0) }
				.store(in: cancellable)
		}

	}

}

// MARK: - Private Methods

private extension JobCategoryJobsList.ViewModel {

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

// MARK: - JobCategoryJobsListViewModelOutput

extension JobCategoryJobsList.ViewModel: JobCategoryJobsListViewModelOutput {

	var jobs: JobsSubject {
		Publishers.CombineLatest(
			currentPageRelay,
			allJobsRelay
		)
		.debounce(for: 0.1, scheduler: RunLoop.main)
		.map { Array($1.prefix($0 * Constant.itemsPerPage)) }
		.removeDuplicates()
		.eraseToAnyPublisher()
	}

	var categoryName: String {
		categoryRelay.categoryCellCategoryName
	}

}

// MARK: - JobsSearchViewModelOutput

extension JobCategoryJobsList.ViewModel: JobsSearchViewModelOutput {

	var searchResultJobs: SearchResultJobsSubject {
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

private extension JobCategoryJobsList.ViewModel {

	enum Constant {

		static let itemsPerPage = 20
	}

}
