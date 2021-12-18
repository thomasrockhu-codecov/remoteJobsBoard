import Combine
import CombineCocoa
import CombineExtensions
import UIKit
import WebKit

final class JobsListViewController: BaseCollectionViewController {

	// MARK: - Properties

	private let viewModel: JobsListViewModelType
	private let searchResultsController: UIViewController

	private lazy var dataSource = JobsListDataSource(viewModel: viewModel, collectionView: collectionView, services: services)

	// MARK: - Properties - Views

	private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
	private lazy var refreshControl = UIRefreshControl()

	// MARK: - Properties - Base Class

	override var backgroundColor: UIColor? {
		Color.JobsList.background
	}

	override var navigationItemTitle: String? {
		LocalizedString.NavigationTitle.jobsList
	}

	// MARK: - Initialization

	init(services: ServicesContainer, viewModel: JobsListViewModelType, searchResultsController: UIViewController) {
		self.viewModel = viewModel
		self.searchResultsController = searchResultsController

		super.init(services: services)
	}

	// MARK: - Base Class

	override func bind() {
		super.bind()

		dataSource.bind()
		viewModel.bind()

		let isJobsEmpty = viewModel.outputs.jobs
			.map { $0.isEmpty }
			.removeDuplicates()
			.receive(on: DispatchQueue.main)
			.share(replay: 1)

		subscriptions {
			isJobsEmpty
				.sinkValue { [weak activityIndicator] in
					$0 ? activityIndicator?.startAnimating() : activityIndicator?.stopAnimating()
				}
			isJobsEmpty
				.map { [weak searchResultsController] isEmpty -> UISearchController? in
					guard !isEmpty else { return nil }
					let searchController = UISearchController(searchResultsController: searchResultsController)
					searchController.searchResultsUpdater = searchResultsController as? UISearchResultsUpdating
					return searchController
				}
				.assign(to: \.searchController, on: navigationItem, ownership: .weak)
			viewModel.outputs.jobsLoadingFinished
				.receive(on: DispatchQueue.main)
				.sinkValue { [weak refreshControl] in
					refreshControl?.endRefreshing()
				}
			refreshControl.controlEventPublisher(for: .valueChanged)
				.subscribe(viewModel.inputs.reloadData)
		}
	}

	override func configureSubviews() {
		super.configureSubviews()

		// Activity Indicator.
		activityIndicator.hidesWhenStopped = true
		collectionView.backgroundView = activityIndicator

		// Refresh Control.
		collectionView.refreshControl = refreshControl
	}

}
