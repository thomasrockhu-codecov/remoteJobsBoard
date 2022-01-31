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
		var attributedTitle = AttributedString(LocalizedString.JobDetails.applyButtonTitle)
		attributedTitle.font = .preferredFont(forTextStyle: .title3)
		attributedTitle.foregroundColor = Color.tintColor

		var configuration = UIButton.Configuration.filled()
		configuration.baseBackgroundColor = Color.backgroundColor
		configuration.cornerStyle = .medium
		configuration.attributedTitle = .init(attributedTitle)
		configuration.contentInsets = .init(vertical: Constant.verticalInset, horizontal: Constant.horizontalInset)

		self.configuration = configuration
	}

}

// MARK: - Constants

private extension JobDetailsApplyButton {

	enum Constant {

		static let horizontalInset: CGFloat = 16
		static let verticalInset: CGFloat = 4

	}

}
