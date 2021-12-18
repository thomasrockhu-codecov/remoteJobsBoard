import UIKit

final class JobDetailsDataSource: BaseCollectionViewDataSource<JobDetailsSections> {

	// MARK: - Properties

	private let viewModel: JobDetailsViewModelType

	// MARK: - Initialization

	init(viewModel: JobDetailsViewModelType, collectionView: UICollectionView, services: ServicesContainer) {
		self.viewModel = viewModel

		super.init(collectionView: collectionView, services: services) {
			switch $2 {
			case .jobTitle(let jobTitle):
				let cell: JobDetailsTitleCell = try $0.dequeueReusableCell(for: $1)
				cell.configure(with: jobTitle)
				return cell
			case .description(let description):
				let cell: JobDetailsDescriptionCell = try $0.dequeueReusableCell(for: $1)
				cell.configure(with: description)
				cell.bind(to: viewModel)
				return cell
			case .companyName(let companyName):
				let cell: JobDetailsCompanyNameCell = try $0.dequeueReusableCell(for: $1)
				cell.configure(with: companyName)
				return cell
			case .tag(let tag):
				let cell: JobDetailsTagCell = try $0.dequeueReusableCell(for: $1)
				cell.configure(with: tag)
				return cell
			}
		}
	}

	// MARK: - Base Class

	override func makeCollectionViewLayout() -> UICollectionViewLayout {
		UICollectionViewCompositionalLayout { [weak self] index, environment in
			guard let self = self else { return nil }
			let item = self.layoutItem(for: environment, index: index)
			let group = self.layoutGroup(with: item, index: index)
			return self.layoutSection(with: group, index: index)
		}
	}

	override func configureCollectionView(_ collectionView: UICollectionView) {
		super.configureCollectionView(collectionView)

		collectionView.register(cellClass: JobDetailsTitleCell.self)
		collectionView.register(cellClass: JobDetailsDescriptionCell.self)
		collectionView.register(cellClass: JobDetailsCompanyNameCell.self)
		collectionView.register(cellClass: JobDetailsTagCell.self)
	}

	override func bind() {
		super.bind()

		viewModel.outputs.job
			.subscribe(on: mappingQueue)
			.map { JobDetailsSections(job: $0).snapshot }
			.receive(on: snapshotQueue)
			.sinkValue { [weak self] in self?.apply($0, animatingDifferences: false) }
			.store(in: subscriptions)
	}

}

// MARK: - Private Methods - Layout

private extension JobDetailsDataSource {

	func layoutGroup(with item: NSCollectionLayoutItem, index: Int) -> NSCollectionLayoutGroup {
		let heightDimension: NSCollectionLayoutDimension
		switch itemIdentifier(for: index)?.section {
		case .tags:
			heightDimension = .estimated(Constant.tagHeight)
		case .description:
			heightDimension = .estimated(Constant.descriptionHeight)
		case .headline:
			heightDimension = .estimated(Constant.headlineHeight)
		default:
			heightDimension = .estimated(Constant.defaultSize)
		}

		let subitems: [NSCollectionLayoutItem]
		switch itemIdentifier(for: index)?.section {
		case .tags:
			subitems = [item, item, item, item, item, item]
		default:
			subitems = [item]
		}

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: subitems)
		group.interItemSpacing = .fixed(Constant.spacing)
		return group
	}

	func layoutItem(for environment: NSCollectionLayoutEnvironment, index: Int) -> NSCollectionLayoutItem {
		let widthDimension: NSCollectionLayoutDimension
		switch itemIdentifier(for: index) {
		case .tag:
			widthDimension = .estimated(Constant.defaultSize)
		default:
			widthDimension = .fractionalWidth(1)
		}

		let heightDimension: NSCollectionLayoutDimension
		switch itemIdentifier(for: index) {
		case .tag:
			heightDimension = .estimated(Constant.tagHeight)
		case .companyName:
			heightDimension = .estimated(Constant.companyNameHeight)
		case .jobTitle:
			heightDimension = .estimated(Constant.jobTitleHeight)
		case .description:
			heightDimension = .estimated(Constant.descriptionHeight)
		default:
			heightDimension = .estimated(Constant.defaultSize)
		}

		let size = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
		return NSCollectionLayoutItem(layoutSize: size)
	}

	func layoutSection(with group: NSCollectionLayoutGroup, index: Int) -> NSCollectionLayoutSection {
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsetsReference = .layoutMargins
		section.interGroupSpacing = Constant.spacing
		section.contentInsets = NSDirectionalEdgeInsets(inset: Constant.spacing)
		return section
	}

}

// MARK: - Constants

private extension JobDetailsDataSource {

	enum Constant {

		static let tagHeight: CGFloat = 50
		static let descriptionHeight: CGFloat = 500
		static let jobTitleHeight: CGFloat = 50
		static let companyNameHeight: CGFloat = 43
		static let defaultSize: CGFloat = 100

		static let spacing: CGFloat = 8

		static let headlineHeight = jobTitleHeight + companyNameHeight

	}

}
