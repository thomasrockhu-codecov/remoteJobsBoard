import CombineExtensions
import UIKit

/// Base class for all collection view data sources.
class BaseCollectionViewDataSource<Sections: DataSourceSections>:
UICollectionViewDiffableDataSource<Sections.SectionModel, Sections.SectionItem> {

    // MARK: - Typealiases

    typealias SectionItem = Sections.SectionItem
    typealias SectionModel = Sections.SectionModel
    typealias DataSourceSnapshot = Sections.DataSourceSnapshot
    typealias BaseCellProvider = (UICollectionView, IndexPath, SectionItem) throws -> UICollectionViewCell

    // MARK: - Properties

    let logger: LoggerServiceType

    weak var collectionView: UICollectionView?

    let subscriptions = CombineCancellable()

    var mappingQueue: DispatchQueue { mappingQueueRelay }
    var snapshotQueue: DispatchQueue { snapshotQueueRelay }

    lazy var mappingQueueRelay = DispatchQueue(label: "\(Self.self)MappingQueue", qos: .userInitiated)
    lazy var snapshotQueueRelay = DispatchQueue(label: "\(Self.self)SnapshotQueue", qos: .userInteractive)

    // MARK: - Initialization

    init(collectionView: UICollectionView,
         services: ServicesContainer,
         cellProvider: @escaping BaseCellProvider) {

        self.collectionView = collectionView
        self.logger = services.logger

        super.init(collectionView: collectionView) { [weak logger] in
            do {
                return try cellProvider($0, $1, $2)
            } catch {
                logger?.log(error: error)
                return nil
            }
        }

        configureCollectionView(collectionView)
    }

    // MARK: - Deinitialization

    deinit {
        logger.log(deinitOf: self)
    }

    // MARK: - Public

    func bind() {}

    /// Configures collectionView.
    /// If you override this function, you should call `super` at some point in your implementation.
    func configureCollectionView(_ collectionView: UICollectionView) {
        let layout = makeCollectionViewLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewFlowLayout()
    }

    /// Returns an identifier for the first item at the specified section in the collection view.
    /// - Parameter section: The section of the item in the collection view.
    func itemIdentifier(for section: Int) -> SectionItem? {
        let indexPath = IndexPath(row: 0, section: section)
        return itemIdentifier(for: indexPath)
    }

}
