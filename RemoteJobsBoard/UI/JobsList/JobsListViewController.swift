import Combine
import CombineCocoa
import CombineExtensions
import UIKit
import WebKit

extension JobsList {

	final class ViewController: BaseCollectionViewController {

		// MARK: - Typealiases

		typealias ViewModel = JobsListViewModelType

		// MARK: - Properties

		private let viewModel: ViewModel
		private let searchResultsController: UIViewController

		private lazy var dataSource = DataSource(viewModel: viewModel, collectionView: collectionView, services: services)

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

		init(services: ServicesContainer, viewModel: ViewModel, searchResultsController: UIViewController) {
			self.viewModel = viewModel
			self.searchResultsController = searchResultsController

			super.init(services: services)
		}

		// MARK: - Base Class

		override func bind() {
			super.bind()

			dataSource.bind()
			viewModel.bind()

			let isJobsEmpty = viewModel.output.jobs
				.map { $0.isEmpty }
				.removeDuplicates()
				.receive(on: DispatchQueue.main)
				.share(replay: 1)

			cancellable {
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
				viewModel.output.jobsLoadingFinished
					.receive(on: DispatchQueue.main)
					.sinkValue { [weak refreshControl] in
						refreshControl?.endRefreshing()
					}
				refreshControl.controlEventPublisher(for: .valueChanged)
					.subscribe(viewModel.input.reloadData)
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

}
