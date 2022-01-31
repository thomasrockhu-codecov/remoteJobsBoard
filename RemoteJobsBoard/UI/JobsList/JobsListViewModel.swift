import Combine
import CombineExtensions
import Foundation

extension JobsList {

	final class ViewModel: BaseViewModel<RootCoordinator.RouteModel>, JobsListViewModelType, JobsSearchViewModelType, JobsListViewModelInput, JobsSearchViewModelInput {

		// MARK: - Properties

		private let api: APIServiceType

		private let currentPageRelay = CurrentValueRelay<Int>(1)
		private let currentSearchPageRelay = CurrentValueRelay<Int>(1)
		private let allJobsRelay = CurrentValueRelay<[Job]>([])
		private let jobsLoadingFinishedRelay = PassthroughRelay<Void>()

		// MARK: - Properties - JobsListViewModelInput

		let showJobDetails = ShowJobDetailsSubject()
		let reloadData = ReloadDataSubject()
		let showNextPage = NextPageSubject()
		let showCategoryJobs = ShowCategoryJobsSubject()

		// MARK: - Properties - JobsSearchViewModelInput

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

			cancellable {
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
			.store(in: cancellable)
		}

	}

}

// MARK: - Private Methods

private extension JobsList.ViewModel {

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

// MARK: - JobsListViewModelOutput

extension JobsList.ViewModel: JobsListViewModelOutput {

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
		.debounce(for: 0.1, scheduler: RunLoop.main)
		.map { Array($1.prefix($0 * Constant.itemsPerPage)) }
		.removeDuplicates()
		.eraseToAnyPublisher()
	}

}

// MARK: - JobsSearchViewModelOutput

extension JobsList.ViewModel: JobsSearchViewModelOutput {

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

private extension JobsList.ViewModel {

	enum Constant {

		static let itemsPerPage = 20
	}

}
