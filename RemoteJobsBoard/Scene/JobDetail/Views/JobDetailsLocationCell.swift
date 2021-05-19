import UIKit

final class JobDetailsLocationCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    private typealias Color = RemoteJobsBoard.Color.LocationCell

    // MARK: - Properties

    private lazy var locationTitleLabel = UILabel()

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Location Title Label.
        locationTitleLabel.textColor = Color.locationTextColor
        locationTitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        locationTitleLabel.numberOfLines = 0

        locationTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        locationTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        locationTitleLabel.add(to: contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)]
        }
    }

}

// MARK: - Public Methods

extension JobDetailsLocationCell {

    func configure(location: String) {
        locationTitleLabel.text = location
    }

}
