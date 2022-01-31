import UIKit

extension JobsSearch {

	final class ResultsController: BaseCollectionViewController {

		// MARK: - Typealiases

		typealias ViewModel = JobsSearchViewModelType

		// MARK: - Properties

		private let viewModel: ViewModel

		private lazy var dataSource = DataSource(viewModel: viewModel, collectionView: collectionView, services: services)

		// MARK: - Properties - Base Class

		override var backgroundColor: UIColor? {
			Color.JobsList.background
		}

		// MARK: - Initialization

		init(services: ServicesContainer, viewModel: ViewModel) {
			self.viewModel = viewModel

			super.init(services: services)
		}

		// MARK: - Base Class

		override func bind() {
			super.bind()

			dataSource.bind()
		}

	}

}

// MARK: - UISearchResultsUpdating

extension JobsSearch.ResultsController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text
		viewModel.searchResultsInput.searchText.accept(text)
	}

}
