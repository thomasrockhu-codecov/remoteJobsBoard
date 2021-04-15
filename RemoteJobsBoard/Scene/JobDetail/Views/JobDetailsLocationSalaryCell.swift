import UIKit

final class JobDetailsLocationSalaryCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    private typealias Color = RemoteJobsBoard.Color.LocationSalaryCell

    // MARK: - Properties

    private lazy var locationTitleLabel = UILabel()
    private lazy var salaryLabel = UILabel()

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Stack View.
        let stackView = UIStackView()
        stackView.spacing = Constant.horizontalSpacing
        stackView.alignment = .top

        stackView.add(to: contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)]
        }

        // Location Title Label.
        locationTitleLabel.textColor = Color.textColor
        locationTitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        locationTitleLabel.numberOfLines = 0

        locationTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        locationTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        locationTitleLabel.addAsArrangedSubview(to: stackView)

        // Salary Label.
        salaryLabel.textColor = Color.textColor
        salaryLabel.font = .preferredFont(forTextStyle: .subheadline)
        salaryLabel.numberOfLines = 0
        salaryLabel.textAlignment = .right

        salaryLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        salaryLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        salaryLabel.addAsArrangedSubview(to: stackView)
    }

}

// MARK: - Public Methods

extension JobDetailsLocationSalaryCell {

    func configure(location: String?, salary: String?) {
        locationTitleLabel.text = location
        salaryLabel.text = salary
    }

}

// MARK: - Constants

private extension JobDetailsLocationSalaryCell {

    enum Constant {

        static let horizontalSpacing: CGFloat = 16

    }

}
