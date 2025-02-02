import UIKit

extension JobsSearch {

	final class DataSource: BaseCollectionViewDataSource<Sections> {

		// MARK: - Typealiases

		typealias ViewModel = ResultsController.ViewModel

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
				guard let self = self else { return nil }
				let item = self.layoutItem(for: environment, section: index)
				let group = Self.layoutGroup(with: item)
				return self.layoutSection(with: group, index: index)
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
				viewModel.searchResultsOutput.searchResultJobs
					.subscribe(on: mappingQueue)
					.map { Sections(jobs: $0).snapshot }
					.receive(on: snapshotQueue)
					.sinkValue { [weak self] in self?.apply($0) }
				collectionView.didSelectItemPublisher
					.sinkValue { [weak self] indexPath in
						guard let self = self else { return }
						switch self.itemIdentifier(for: indexPath) {
						case .none:
							self.logger.log(error: CommonError.unexpectedItemIdentifier)
						case .job(let job):
							self.viewModel.searchResultsInput.showJobDetails.accept(job)
						}
					}
				collectionView.willDisplayCellPublisher
					.compactMap { [weak collectionView] _, indexPath -> Void? in
						guard let collectionView = collectionView else { return nil }
						let rowToTrigger = collectionView.numberOfItems(inSection: 0) - Constant.itemPaginationOffset
						return indexPath.row == rowToTrigger ? () : nil
					}
					.subscribe(viewModel.searchResultsInput.showNextSearchPage)
			}
		}

	}

}

// MARK: - Private Methods - Layout

private extension JobsSearch.DataSource {

	static func layoutGroup(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																					 heightDimension: item.layoutSize.heightDimension)
		return .horizontal(layoutSize: groupSize, subitems: [item])
	}

	func layoutItemWidthDimension(for environment: NSCollectionLayoutEnvironment, section: Int) -> NSCollectionLayoutDimension {
		switch itemIdentifier(for: section) {
		case .none:
			return .fractionalWidth(1)
		case .job:
			let floatNumberOfItems = environment.container.contentSize.width / Constant.approximateItemWidth
			let intNumberOfItems = Int(floatNumberOfItems.rounded(.up))
			return .fractionalWidth(1 / CGFloat(intNumberOfItems))
		}
	}

	func layoutItemHeightDimension(for section: Int) -> NSCollectionLayoutDimension {
		switch itemIdentifier(for: section) {
		case .none:
			return .absolute(40)
		case .job:
			return .absolute(Constant.jobCellHeight)
		}
	}

	func layoutItemContentInsets(for section: Int) -> NSDirectionalEdgeInsets {
		switch itemIdentifier(for: section) {
		case .none:
			return .zero
		case .job:
			return .init(inset: Constant.jobCellEdgeInsets)
		}
	}

	func layoutItem(for environment: NSCollectionLayoutEnvironment, section: Int) -> NSCollectionLayoutItem {
		let widthDimension = layoutItemWidthDimension(for: environment, section: section)
		let heightDimension = layoutItemHeightDimension(for: section)
		let itemSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)

		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = layoutItemContentInsets(for: section)
		return item
	}

	func layoutSection(with group: NSCollectionLayoutGroup, index: Int) -> NSCollectionLayoutSection {
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsetsReference = .layoutMargins
		return section
	}

}

// MARK: - Constants

private extension JobsSearch.DataSource {

	enum Constant {

		static let approximateItemWidth: CGFloat = 740

		static let jobCellHeight: CGFloat = 100
		static let jobCellEdgeInsets: CGFloat = 4
		static let itemPaginationOffset = 1

	}

}
