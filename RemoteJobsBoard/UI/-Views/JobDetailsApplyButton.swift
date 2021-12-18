import UIKit

final class JobDetailsApplyButton: UIButton {

	// MARK: - Typealiases

	private typealias Color = RemoteJobsBoard.Color.ApplyButton

	// MARK: - Initialization

	convenience init() {
		self.init(type: .system)

		commonInit()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)

		commonInit()
	}

}

// MARK: - Private Methods

private extension JobDetailsApplyButton {

	func commonInit() {
		setTitle(LocalizedString.JobDetails.applyButtonTitle, for: .normal)
		tintColor = Color.tintColor
		backgroundColor = Color.backgroundColor
		layer.cornerRadius = Constant.cornerRadius
		titleLabel?.font = .preferredFont(forTextStyle: .title3)

		contentEdgeInsets = UIEdgeInsets(
			top: Constant.verticalContentEdgeInset,
			left: Constant.horizontalContentEdgeInset,
			bottom: Constant.verticalContentEdgeInset,
			right: Constant.horizontalContentEdgeInset
		)
	}

}

// MARK: - Constants

private extension JobDetailsApplyButton {

	enum Constant {

		static let cornerRadius: CGFloat = 8
		static let horizontalContentEdgeInset: CGFloat = 16
		static let verticalContentEdgeInset: CGFloat = 4

	}

}
