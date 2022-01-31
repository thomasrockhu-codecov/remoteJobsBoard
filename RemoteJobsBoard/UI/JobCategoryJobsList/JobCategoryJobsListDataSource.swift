import Combine
import UIKit

extension JobCategoryJobsList {

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
		}

		override func bind() {
			super.bind()

			guard let collectionView = collectionView else { return }

			cancellable {
				viewModel.output.jobs
					.subscribe(on: mappingQueue)
					.map { Sections(jobs: $0).snapshot }
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

private extension JobCategoryJobsList.DataSource {

	func shouldTriggerNextPage(displayingCellAt indexPath: IndexPath) -> Bool {
		guard let collectionView = collectionView else { return false }
		let rowToTrigger = collectionView.numberOfItems(inSection: Constant.jobsSectionIndex) - Constant.itemPaginationOffset
		return indexPath.row == rowToTrigger
	}

	func handleSelection(ofItemAt indexPath: IndexPath) {
		switch itemIdentifier(for: indexPath) {
		case .none:
			logger.log(error: CommonError.unexpectedItemIdentifier)
		case .job(let job):
			viewModel.input.showJobDetails.accept(job)
		}
	}

}

// MARK: - Private Methods - Layout

private extension JobCategoryJobsList.DataSource {

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
		let groupSize = NSCollectionLayoutSize(
			widthDimension: layoutJobGroupWidthDimension(with: environment),
			heightDimension: .absolute(Constant.jobCellHeight)
		)
		return .horizontal(layoutSize: groupSize, subitems: [item])
	}

	static func layoutSection(for model: SectionItem, with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsetsReference = .layoutMargins
		section.contentInsets = NSDirectionalEdgeInsets(inset: Constant.contentInsets)
		section.interGroupSpacing = Constant.contentInsets
		return section
	}

}

// MARK: - Constants

private extension JobCategoryJobsList.DataSource {

	enum Constant {

		/// `740`.
		static let approximateItemWidth: CGFloat = 740
		/// `100`.
		static let jobCellHeight: CGFloat = 100
		/// `8`.
		static let contentInsets: CGFloat = 8
		/// `1`.
		static let itemPaginationOffset = 1
		/// `1`.
		static let jobsSectionIndex = 0

	}

}
