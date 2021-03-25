import UIKit

final class JobsListViewController: BaseCollectionViewController {

    // MARK: - Properties

    private let viewModel: JobsListViewModelType

    // MARK: - Initialization

    init(services: ServicesContainer, viewModel: JobsListViewModelType) {
        self.viewModel = viewModel

        super.init(services: services)
    }

    // MARK: - Base Class

    override func bind() {
        super.bind()

        viewModel.bind()
    }

}
