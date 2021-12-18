import CombineExtensions
import UIKit

/// Base class for all table view controllers.
class BaseTableViewController: UITableViewController {

	// MARK: - Properties

	let services: ServicesContainer

	let subscriptions = CombineCancellable()

	var navigationItemTitle: String? { nil }
	var backgroundColor: UIColor? { .systemBackground }

	// MARK: - Initialization

	init(style: UITableView.Style, services: ServicesContainer) {
		self.services = services

		super.init(style: style)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Deinitialization

	deinit {
		services.logger.log(deinitOf: self)
	}

	// MARK: - Base Class

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.backgroundColor = backgroundColor
		navigationItem.title = navigationItemTitle

		configureSubviews()
		bind()
	}

	// MARK: - Public {

	func configureSubviews() {}
	func bind() {}

}
