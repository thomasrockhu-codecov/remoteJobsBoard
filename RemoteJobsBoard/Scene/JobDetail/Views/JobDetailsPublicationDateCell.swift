import UIKit

final class JobDetailsPublicationDateCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    private typealias Color = RemoteJobsBoard.Color.PublicationDateCell

    // MARK: - Properties

    private lazy var publicationDateLabel = UILabel()

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Job Title Label.
        publicationDateLabel.textColor = Color.publicationDateTextColor
        publicationDateLabel.font = .preferredFont(forTextStyle: .footnote)
        publicationDateLabel.numberOfLines = 0

        publicationDateLabel.add(to: contentView) {
            [$0.leadingAnchor.constraint(greaterThanOrEqualTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)]
        }
    }

}

// MARK: - Public Methods

extension JobDetailsPublicationDateCell {

    func configure(with publicationDate: String) {
        publicationDateLabel.text = publicationDate
    }

}
