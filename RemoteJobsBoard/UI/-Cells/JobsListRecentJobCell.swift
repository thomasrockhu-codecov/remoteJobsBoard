import UIKit

final class JobsListRecentJobCell: BaseCollectionViewCell {

	// MARK: - Typealiases

	typealias Color = RemoteJobsBoard.Color.RecentJobCell

	// MARK: - Properties

	private lazy var jobTitleLabel = UILabel()
	private lazy var companyNameLabel = UILabel()
	private lazy var publicationDateLabel = UILabel()

	// MARK: - Base Class

	override func configureSubviews() {
		super.configureSubviews()

		backgroundColor = Color.background
		layer.cornerRadius = Constant.cornerRadius

		// Vertical Stack View.
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = Constant.verticalSpacing

		stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
		stackView.add(to: contentView) {
			$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor, constant: Constant.horizontalEdgeOffset)
			$0.topAnchor.constraint(greaterThanOrEqualTo: $1.topMarginAnchor, constant: Constant.verticalEdgeOffset)
			$1.bottomMarginAnchor.constraint(greaterThanOrEqualTo: $0.bottomAnchor, constant: Constant.verticalEdgeOffset)
			$0.centerYAnchor.constraint(equalTo: $1.centerYMarginAnchor)
		}

		// Job Title Label.
		jobTitleLabel.font = .preferredFont(forTextStyle: .headline)
		jobTitleLabel.textColor = Color.jobTitleTextColor

		jobTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
		jobTitleLabel.addAsArrangedSubview(to: stackView)

		// Company Name Label.
		companyNameLabel.font = .preferredFont(forTextStyle: .subheadline)
		companyNameLabel.textColor = Color.companyNameTextColor

		companyNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
		companyNameLabel.addAsArrangedSubview(to: stackView)

		// Publication Date Label.
		publicationDateLabel.font = .preferredFont(forTextStyle: .caption1)
		publicationDateLabel.textColor = Color.publicationDateTextColor

		publicationDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		publicationDateLabel.add(to: contentView) {
			$0.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: Constant.horizontalSpacing)
			$0.topAnchor.constraint(equalTo: $1.topAnchor, constant: Constant.verticalEdgeOffset)
			$1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor, constant: Constant.horizontalEdgeOffset)
			$1.bottomMarginAnchor.constraint(greaterThanOrEqualTo: $0.bottomAnchor, constant: Constant.verticalEdgeOffset)
		}
	}

}

// MARK: - Public Methods

extension JobsListRecentJobCell {

	func configure(with model: JobsListRecentJobCellModel) {
		jobTitleLabel.text = model.recentJobCellJobTitle
		companyNameLabel.text = model.recentJobCellCompanyName
		publicationDateLabel.text = model.recentJobCellPublicationDate
	}

}

// MARK: - Constants

private extension JobsListRecentJobCell {

	enum Constant {

		static let verticalEdgeOffset: CGFloat = 12
		static let horizontalEdgeOffset: CGFloat = 12

		static let horizontalSpacing: CGFloat = 24
		static let verticalSpacing: CGFloat = 8

		static let cornerRadius: CGFloat = 8

	}

}
