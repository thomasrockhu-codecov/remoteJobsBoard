import CombineExtensions
import UIKit

/// Base class for all table view cells.
class BaseTableViewCell: UITableViewCell {

	// MARK: - Properties

	private(set) var reusableSubscriptions = CombineCancellable()

	// MARK: - Initialization

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		configureSubviews()
		reusableBind()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Base Class

	override func prepareForReuse() {
		super.prepareForReuse()

		reusableSubscriptions = CombineCancellable()
		reusableBind()
	}

	// MARK: - Public

	/// Configures cell subviews.
	func configureSubviews() {}

	func reusableBind() {}

}
