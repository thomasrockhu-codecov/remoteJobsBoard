import Combine
import UIKit

extension JobsList {

	final class DataSource: BaseCollectionViewDataSource<Sections> {

		// MARK: - Typealiases

		typealias ViewModel = ViewController.ViewModel

		// MARK: - Properties

		private let viewModel: ViewModel

		// MARK: - Initialization

		init(viewModel: ViewModel, collectionView: UICollectionView, services: ServicesContainer) {
			self.viewModel = viewModel

			super.init(collectionView: collectionView, services: services) {
				switch $2 {
				case .job(let job):
					let cell: JobsListRecentJobCell = try $0.dequeueReusableCell(for: $1)
					cell.configure(with: job)
					return cell
				case .category(let category):
					let cell: JobsListCategoryCell = try $0.dequeueReusableCell(for: $1)
					cell.configure(with: category)
					return cell
				}
			}
		}

		// MARK: - Base Class

		override func makeCollectionViewLayout() -> UICollectionViewLayout {
			UICollectionViewCompositionalLayout { [weak self] index, environment in
				guard let sectionItem = self?.itemIdentifier(for: index) else { return nil }
				let group = Self.layoutGroup(for: sectionItem, with: Self.layoutItem(), with: environment)
				return Self.layoutSection(for: sectionItem, with: group)
			}
		}

		override func configureCollectionView(_ collectionView: UICollectionView) {
			super.configureCollectionView(collectionView)

			collectionView.register(cellClass: JobsListRecentJobCell.self)
			collectionView.register(cellClass: JobsListCategoryCell.self)
		}

		override func bind() {
			super.bind()

			guard let collectionView = collectionView else { return }

			cancellable {
				Publishers.CombineLatest(
					viewModel.output.jobCategories,
					viewModel.output.jobs
				)
				.subscribe(on: mappingQueue)
				.map { Sections(categories: $0, jobs: $1).snapshot }
				.receive(on: snapshotQueue)
				.sinkValue { [weak self] in self?.apply($0) }
				collectionView.didSelectItemPublisher
					.sinkValue { [weak self] in self?.handleSelection(ofItemAt: $0) }
				collectionView.willDisplayCellPublisher
					.filter { [weak self] in self?.shouldTriggerNextPage(displayingCellAt: $1) ?? false }
					.map { _ in () }
					.subscribe(viewModel.input.showNextPage)
			}
		}

	}

}

// MARK: - Private Methods

private extension JobsList.DataSource {

	func shouldTriggerNextPage(displayingCellAt indexPath: IndexPath) -> Bool {
		guard let collectionView = collectionView else { return false }
		let jobsSectionIndex = JobsList.Sections.Constant.jobsSectionIndex
		let rowToTrigger = collectionView.numberOfItems(inSection: jobsSectionIndex) - Constant.itemPaginationOffset
		return indexPath.row == rowToTrigger
	}

	func handleSelection(ofItemAt indexPath: IndexPath) {
		switch itemIdentifier(for: indexPath) {
		case .none:
			logger.log(error: CommonError.unexpectedItemIdentifier)
		case .job(let job):
			viewModel.input.showJobDetails.accept(job)
		case .category(let category):
			viewModel.input.showCategoryJobs.accept(category)
		}
	}

}

// MARK: - Private Methods - Layout

private extension JobsList.DataSource {

	static func layoutItem() -> NSCollectionLayoutItem {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalHeight(1)
		)
		return .init(layoutSize: itemSize)
	}

	static func layoutJobGroupWidthDimension(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutDimension {
		let floatNumberOfItems = environment.container.contentSize.width / Constant.approximateItemWidth
		let intNumberOfItems = Int(floatNumberOfItems.rounded(.up))
		return .fractionalWidth(1 / CGFloat(intNumberOfItems))
	}

	static func layoutGroup(for model: SectionItem, with item: NSCollectionLayoutItem, with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup {
		switch model {
		case .category:
			let groupSize = NSCollectionLayoutSize(
				widthDimension: .absolute(Constant.categoryCellWidth),
				heightDimension: .absolute(Constant.categoryCellHeight)
			)
			return .horizontal(layoutSize: groupSize, subitems: [item])
		case .job:
			let groupSize = NSCollectionLayoutSize(
				widthDimension: layoutJobGroupWidthDimension(with: environment),
				heightDimension: .absolute(Constant.jobCellHeight)
			)
			return .horizontal(layoutSize: groupSize, subitems: [item])
		}
	}

	static func layoutSection(for model: SectionItem, with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsetsReference = .layoutMargins
		section.contentInsets = NSDirectionalEdgeInsets(inset: Constant.contentInsets)
		section.interGroupSpacing = Constant.contentInsets

		switch model {
		case .category:
			section.orthogonalScrollingBehavior = .groupPaging
		default:
			break
		}

		return section
	}

}

// MARK: - Constants

private extension JobsList.DataSource {

	enum Constant {

		/// `740`.
		static let approximateItemWidth: CGFloat = 740
		/// `100`.
		static let jobCellHeight: CGFloat = 100
		/// `8`.
		static let contentInsets: CGFloat = 8
		/// `1`.
		static let itemPaginationOffset = 1

		/// `160`.
		static let categoryCellWidth: CGFloat = 160
		/// `100`.
		static let categoryCellHeight: CGFloat = 100

	}

}
