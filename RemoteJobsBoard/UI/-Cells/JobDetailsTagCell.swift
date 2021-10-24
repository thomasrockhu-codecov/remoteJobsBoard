import UIKit

final class JobDetailsTagCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    private typealias Color = RemoteJobsBoard.Color.TagsCell

    // MARK: - Properties

    private lazy var tagLabel = UILabel()
    private lazy var tagLabelBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Tag Label Background View.
        tagLabelBackgroundView.clipsToBounds = true
        tagLabelBackgroundView.layer.cornerRadius = Constant.cornerRadius

        tagLabelBackgroundView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        tagLabelBackgroundView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tagLabelBackgroundView.add(to: contentView) {
            $0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor)
            $0.topAnchor.constraint(equalTo: $1.topMarginAnchor)
            $1.trailingMarginAnchor.constraint(greaterThanOrEqualTo: $0.trailingAnchor)
            $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)
        }

        // Tag Label.
        tagLabel.textColor = Color.tagTextColor
        tagLabel.font = .preferredFont(forTextStyle: .subheadline)
        tagLabel.numberOfLines = 0
        tagLabel.textAlignment = .center

        tagLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        tagLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tagLabel.add(to: tagLabelBackgroundView.contentView) {
            $0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor)
            $0.topAnchor.constraint(equalTo: $1.topMarginAnchor)
            $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor)
            $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)
        }
    }

}

// MARK: - Public Methods

extension JobDetailsTagCell {

    func configure(with tag: String) {
        tagLabel.text = tag
    }

}

// MARK: - Constants

private extension JobDetailsTagCell {

    enum Constant {

        static let cornerRadius: CGFloat = 8

    }

}
