import UIKit

final class JobDetailsCategoryCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    private typealias Color = RemoteJobsBoard.Color.CategoryCell

    // MARK: - Properties

    private lazy var categoryLabel = UILabel()

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Job Title Label.
        categoryLabel.textColor = Color.categoryTextColor
        categoryLabel.font = .preferredFont(forTextStyle: .footnote)
        categoryLabel.numberOfLines = 0

        categoryLabel.add(to: contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)]
        }
    }

}

// MARK: - Public Methods

extension JobDetailsCategoryCell {

    func configure(with categoryName: String) {
        categoryLabel.text = categoryName
    }

}
