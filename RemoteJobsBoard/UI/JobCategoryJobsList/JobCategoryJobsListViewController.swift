import UIKit

extension JobCategoryJobsList {

	final class ViewController: BaseCollectionViewController {

		// MARK: - Typealiases

		typealias ViewModel = JobCategoryJobsListViewModelType

		// MARK: - Properties

		private let viewModel: ViewModel
		private let searchResultsController: UIViewController

		private lazy var dataSource = DataSource(viewModel: viewModel, collectionView: collectionView, services: services)

		// MARK: - Properties - Base Class

		override var backgroundColor: UIColor? {
			Color.JobsList.background
		}

		override var navigationItemTitle: String? {
			viewModel.output.categoryName
		}

		// MARK: - Initialization

		init(viewModel: ViewModel, services: ServicesContainer, searchResultsController: UIViewController) {
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

}

// MARK: - Private Methods

private extension JobCategoryJobsList.ViewController {

	func configureSearchController() {
		let searchController = UISearchController(searchResultsController: searchResultsController)
		searchController.searchResultsUpdater = searchResultsController as? UISearchResultsUpdating
		navigationItem.searchController = searchController
	}

}
