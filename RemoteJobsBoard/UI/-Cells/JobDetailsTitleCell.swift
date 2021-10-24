import UIKit

final class JobDetailsTitleCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    private typealias Color = RemoteJobsBoard.Color.JobTitleCell

    // MARK: - Properties

    private lazy var jobTitleLabel = UILabel()

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Job Title Label.
        jobTitleLabel.textColor = Color.jobTitleTextColor
        jobTitleLabel.font = .preferredFont(forTextStyle: .title1)
        jobTitleLabel.numberOfLines = 0

        jobTitleLabel.add(to: contentView) {
            $0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor)
            $0.topAnchor.constraint(equalTo: $1.topMarginAnchor)
            $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor)
            $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)
        }
    }

}

// MARK: - Public Methods

extension JobDetailsTitleCell {

    func configure(with jobTitle: String) {
        jobTitleLabel.text = jobTitle
    }

}
