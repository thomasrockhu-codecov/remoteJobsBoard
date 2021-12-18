import UIKit

final class JobDetailsCompanyNameCell: BaseJobDetailsCell {

	// MARK: - Typealiases

	private typealias Color = RemoteJobsBoard.Color.CompanyNameCell

	// MARK: - Properties

	private let companyNameLabel = UILabel()

	// MARK: - Base Class

	override func configureSubviews() {
		super.configureSubviews()

		// Job Title Label.
		companyNameLabel.textColor = Color.companyNameTextColor
		companyNameLabel.font = .preferredFont(forTextStyle: .title2)
		companyNameLabel.numberOfLines = 0

		companyNameLabel.add(to: contentView) {
			$0.leadingAnchor.constraint(equalTo: $1.leadingAnchor)
			$0.topAnchor.constraint(equalTo: $1.topAnchor)
			$1.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
			$1.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
		}
	}

}

// MARK: - Public Methods

extension JobDetailsCompanyNameCell {

	func configure(with companyName: String) {
		companyNameLabel.text = companyName
	}

}
