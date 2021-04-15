import UIKit

final class JobDetailsViewController: BaseTableViewController {

    // MARK: - Properties

    private let viewModel: JobDetailViewModelType

    private lazy var dataSource = JobDetailsDataSource(viewModel: viewModel, tableView: tableView, services: services)

    // MARK: - Properties - Base Class

    override var backgroundColor: UIColor? {
        Color.JobsList.background
    }

    // MARK: - Initialization

    init(viewModel: JobDetailViewModelType, services: ServicesContainer) {
        self.viewModel = viewModel

        super.init(style: .grouped, services: services)
    }

    // MARK: - Base Class

    override func bind() {
        super.bind()

        navigationItem.largeTitleDisplayMode = .never

        dataSource.bind()
        viewModel.bind()
    }

}
