import Combine
import CombineCocoa
import UIKit

final class JobDetailsViewController: BaseCollectionViewController {

    // MARK: - Properties

    private let viewModel: JobDetailsViewModelType

    private lazy var dataSource = JobDetailsDataSource(viewModel: viewModel, collectionView: collectionView, services: services)

    // MARK: - Properties - Views

    private lazy var applyButton = JobDetailsApplyButton()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
    }

    override func bind() {
        super.bind()

        dataSource.bind()
        viewModel.bind()

        applyButton.controlEventPublisher(for: .touchUpInside)
            .subscribe(viewModel.inputs.applyToJob)
            .store(in: &subscriptionsStore)

        applyButton.publisher(for: \.bounds)
            .map { $0.height }
            .removeDuplicates()
            .assign(to: \.contentInset.bottom, on: collectionView, ownership: .weak)
            .store(in: &subscriptionsStore)
    }

    override func configureSubviews() {
        super.configureSubviews()

        // Apply Button.
        applyButton.add(to: view) {
            [$0.centerXAnchor.constraint(equalTo: $1.centerXSafeAnchor),
             $0.widthAnchor.constraint(greaterThanOrEqualTo: $1.widthAnchor, multiplier: Constant.applyButtonWidthMultiplier),
             $0.heightAnchor.constraint(greaterThanOrEqualToConstant: Constant.applyButtonHeight),
             $1.bottomSafeAnchor.constraint(equalTo: $0.bottomSafeAnchor)]
        }
    }

}

// MARK: - Constants

private extension JobDetailsViewController {

    enum Constant {

        static let applyButtonWidthMultiplier: CGFloat = 0.75
        static let applyButtonHeight: CGFloat = 56

    }

}
