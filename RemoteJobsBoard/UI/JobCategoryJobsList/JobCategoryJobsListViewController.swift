import UIKit

final class JobCategoryJobsListViewController: BaseCollectionViewController {

	// MARK: - Properties

	private let viewModel: JobCategoryJobsListViewModelType
	private let searchResultsController: UIViewController

	private lazy var dataSource = JobCategoryJobsListDataSource(viewModel: viewModel, collectionView: collectionView, services: services)

	// MARK: - Properties - Base Class

	override var backgroundColor: UIColor? {
		Color.JobsList.background
	}

	override var navigationItemTitle: String? {
		viewModel.outputs.categoryName
	}

	// MARK: - Initialization

	init(viewModel: JobCategoryJobsListViewModelType, services: ServicesContainer, searchResultsController: UIViewController) {
		self.viewModel = viewModel
		self.searchResultsController = searchResultsController

		super.init(services: services)
	}

	// MARK: - Base Class

	override func viewDidLoad() {
		super.viewDidLoad()

		configureSearchController()
	}

	override func bind() {
		super.bind()

		dataSource.bind()
		viewModel.bind()
	}

}

// MARK: - Private Methods

private extension JobCategoryJobsListViewController {

	func configureSearchController() {
		let searchController = UISearchController(searchResultsController: searchResultsController)
		searchController.searchResultsUpdater = searchResultsController as? UISearchResultsUpdating
		navigationItem.searchController = searchController
	}

}
