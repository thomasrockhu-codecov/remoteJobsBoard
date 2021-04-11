import Combine
import CombineExt
import UIKit
import WebKit

final class JobsListViewController: BaseCollectionViewController {

    // MARK: - Properties

    private let viewModel: JobsListViewModelType

    private lazy var dataSource = JobsListDataSource(viewModel: viewModel, collectionView: collectionView, services: services)

    // MARK: - Properties - Views

    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Properties - Base Class

    override var backgroundColor: UIColor? {
        Color.JobsList.background
    }

    override var navigationItemTitle: String? {
        LocalizedString.NavigationTitle.jobsList
    }

    // MARK: - Initialization

    init(services: ServicesContainer, viewModel: JobsListViewModelType) {
        self.viewModel = viewModel

        super.init(services: services)
    }

    // MARK: - Base Class

    override func bind() {
        super.bind()

        dataSource.bind()
        viewModel.bind()

        viewModel.outputs.jobs
            .map { $0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak activityIndicator] in
                $0 ? activityIndicator?.startAnimating() : activityIndicator?.stopAnimating()
            }
            .store(in: &subscriptionsStore)
    }

    override func configureSubviews() {
        super.configureSubviews()

        activityIndicator.hidesWhenStopped = true
        collectionView.backgroundView = activityIndicator
    }

}
