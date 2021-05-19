import UIKit

final class JobDetailsTermsCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    private typealias Color = RemoteJobsBoard.Color.TermsCell

    // MARK: - Properties

    private lazy var salaryLabel = UILabel()
    private lazy var jobTypeLabel = UILabel()
    private lazy var salaryLabelBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
    private lazy var jobTypeLabelBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Stack View.
        let stackView = UIStackView()
        stackView.spacing = Constant.horizontalSpacing
        stackView.alignment = .center

        stackView.add(to: contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(greaterThanOrEqualTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)]
        }

        // Salary Label Background.
        configureLabelBackgroundView(salaryLabelBackgroundView)
        salaryLabelBackgroundView.addAsArrangedSubview(to: stackView)

        // Salary Label.
        configureLabel(salaryLabel)
        salaryLabel.add(to: salaryLabelBackgroundView.contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)]
        }

        // Job Type Label Background.
        configureLabelBackgroundView(jobTypeLabelBackgroundView)
        jobTypeLabelBackgroundView.addAsArrangedSubview(to: stackView)

        // Job Type Label.
        configureLabel(jobTypeLabel)
        jobTypeLabel.add(to: jobTypeLabelBackgroundView.contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)]
        }
    }

}

// MARK: - Public Methods

extension JobDetailsTermsCell {

    func configure(jobType: String?, salary: String?) {
        jobTypeLabelBackgroundView.isHidden = jobType == nil
        salaryLabelBackgroundView.isHidden = salary == nil
        jobTypeLabel.text = jobType
        salaryLabel.text = salary
    }

}

// MARK: - Private Methods

private extension JobDetailsTermsCell {

    func configureLabelBackgroundView(_ labelBackgroundView: UIVisualEffectView) {
        labelBackgroundView.clipsToBounds = true
        labelBackgroundView.layer.cornerRadius = Constant.salaryCornerRadius

        labelBackgroundView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        labelBackgroundView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    func configureLabel(_ label: UILabel) {
        label.textColor = Color.termTextColor
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .center

        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

}

// MARK: - Constants

private extension JobDetailsTermsCell {

    enum Constant {

        static let horizontalSpacing: CGFloat = 16
        static let salaryCornerRadius: CGFloat = 8

    }

}
