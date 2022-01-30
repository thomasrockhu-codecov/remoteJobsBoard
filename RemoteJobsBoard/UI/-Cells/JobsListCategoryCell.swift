import UIKit

final class JobsListCategoryCell: BaseCollectionViewCell {

	private typealias Color = RemoteJobsBoard.Color.CategoryCell

	// MARK: - Properties

	private lazy var categoryTitleLabel = UILabel()
	private lazy var categoryIconImageView = UIImageView()

	// MARK: - Base Class

	override func configureSubviews() {
		super.configureSubviews()

		backgroundColor = Color.background
		layer.cornerRadius = Constant.cornerRadius

		// Stack View.
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = Constant.verticalSpacing
		stackView.alignment = .center

		stackView.add(to: contentView) {
			$0.leadingAnchor.constraint(equalTo: $1.leadingAnchor, constant: Constant.edgeOffset)
			$0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor, constant: Constant.edgeOffset)
			$1.trailingAnchor.constraint(equalTo: $0.trailingAnchor, constant: Constant.edgeOffset)
			$1.bottomAnchor.constraint(greaterThanOrEqualTo: $0.bottomAnchor, constant: Constant.edgeOffset)
			$0.centerYAnchor.constraint(equalTo: $1.centerYAnchor)
		}

		// Category Icon Image View.
		categoryIconImageView.contentMode = .scaleAspectFit

		categoryIconImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		categoryIconImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		categoryIconImageView.addAsArrangedSubview(to: stackView) { imageView, _ in
			imageView.heightAnchor.constraint(equalToConstant: Constant.iconHeight)
			imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
		}

		// Category Title Label.
		categoryTitleLabel.textColor = Color.categoryTitleTextColor
		categoryTitleLabel.font = .preferredFont(forTextStyle: .headline)
		categoryTitleLabel.textAlignment = .center
		categoryTitleLabel.numberOfLines = 2

		categoryTitleLabel.addAsArrangedSubview(to: stackView)
	}
	
}

// MARK: - Public Methods

extension JobsListCategoryCell {

	func configure(with model: JobsListCategoryCellModel) {
		categoryTitleLabel.text = model.categoryCellCategoryName
		categoryIconImageView.image = model.categoryCellCategoryIcon
	}

}

// MARK: - Constants

private extension JobsListCategoryCell {

	enum Constant {

		static let edgeOffset: CGFloat = 4
		static let verticalSpacing: CGFloat = 8
		static let iconHeight: CGFloat = 40

		static let cornerRadius: CGFloat = 8

	}

}
