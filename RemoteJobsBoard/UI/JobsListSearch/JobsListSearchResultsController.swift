import UIKit

final class JobsListSearchResultsController: BaseCollectionViewController {

	// MARK: - Properties

	private let viewModel: JobsListSearchResultsViewModelType

	private lazy var dataSource = JobsListSearchDataSource(viewModel: viewModel, collectionView: collectionView, services: services)

	// MARK: - Properties - Base Class

	override var backgroundColor: UIColor? {
		Color.JobsList.background
	}

	// MARK: - Initialization

	init(services: ServicesContainer, viewModel: JobsListSearchResultsViewModelType) {
		self.viewModel = viewModel

		super.init(services: services)
	}

	// MARK: - Base Class

	override func bind() {
		super.bind()

		dataSource.bind()
	}

}

// MARK: - UISearchResultsUpdating

extension JobsListSearchResultsController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text
		viewModel.searchResultsInputs.searchText.accept(text)
	}

}
