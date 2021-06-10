import UIKit

final class JobDetailsViewController: BaseCollectionViewController {

    // MARK: - Properties

    private let viewModel: JobDetailsViewModelType

    private lazy var dataSource = JobDetailsDataSource(viewModel: viewModel, collectionView: collectionView, services: services)

    // MARK: - Properties - Base Class

    override var backgroundColor: UIColor? {
        Color.JobsList.background
    }

    // MARK: - Initialization

    init(viewModel: JobDetailsViewModelType, services: ServicesContainer) {
        self.viewModel = viewModel

        super.init(services: services)
    }

    // MARK: - Base Class

    override func bind() {
        super.bind()

        navigationItem.largeTitleDisplayMode = .never

        dataSource.bind()
        viewModel.bind()
    }

}
