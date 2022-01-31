import Combine
import CombineCocoa
import UIKit

extension JobDetails {

	final class ViewController: BaseCollectionViewController {

		// MARK: - Typealiases

		typealias ViewModel = JobDetailsViewModelType

		// MARK: - Properties

		private let viewModel: ViewModel

		private lazy var dataSource = DataSource(viewModel: viewModel, collectionView: collectionView, services: services)

		// MARK: - Properties - Views

		private lazy var applyButton = JobDetailsApplyButton()

		// MARK: - Properties - Base Class

		override var backgroundColor: UIColor? {
			Color.JobsList.background
		}

		// MARK: - Initialization

		init(viewModel: ViewModel, services: ServicesContainer) {
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

			cancellable {
				applyButton.controlEventPublisher(for: .touchUpInside)
					.subscribe(viewModel.input.applyToJob)

				applyButton.publisher(for: \.bounds)
					.map(\.height)
					.removeDuplicates()
					.assign(to: \.contentInset.bottom, on: collectionView, ownership: .weak)
			}
		}

		override func configureSubviews() {
			super.configureSubviews()

			// Apply Button.
			applyButton.add(to: view) {
				$0.centerXAnchor.constraint(equalTo: $1.centerXSafeAnchor)
				$0.widthAnchor.constraint(greaterThanOrEqualTo: $1.widthAnchor, multiplier: Constant.applyButtonWidthMultiplier)
				$0.heightAnchor.constraint(greaterThanOrEqualToConstant: Constant.applyButtonHeight)
				$1.bottomSafeAnchor.constraint(equalTo: $0.bottomSafeAnchor)
			}
		}

	}

}

// MARK: - Constants

private extension JobDetails.ViewController {

	enum Constant {

		static let applyButtonWidthMultiplier: CGFloat = 0.75
		static let applyButtonHeight: CGFloat = 56

	}

}
