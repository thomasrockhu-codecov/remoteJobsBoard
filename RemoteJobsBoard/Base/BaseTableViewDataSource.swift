import CombineExtensions
import UIKit

/// Base class for all table view data sources.
class BaseTableViewDataSource<Sections: DataSourceSections>:
UITableViewDiffableDataSource<Sections.SectionModel, Sections.SectionItem> {

    // MARK: - Typealiases

    typealias SectionItem = Sections.SectionItem
    typealias SectionModel = Sections.SectionModel
    typealias DataSourceSnapshot = Sections.DataSourceSnapshot
    typealias BaseCellProvider = (UITableView, IndexPath, SectionItem) throws -> UITableViewCell

    // MARK: - Properties

    let logger: LoggerServiceType

    weak var tableView: UITableView?

    let subscriptions = CombineCancellable()

    var mappingQueue: DispatchQueue { mappingQueueRelay }
    var snapshotQueue: DispatchQueue { snapshotQueueRelay }

    lazy var mappingQueueRelay = DispatchQueue(label: "\(Self.self)MappingQueue", qos: .userInitiated)
    lazy var snapshotQueueRelay = DispatchQueue(label: "\(Self.self)SnapshotQueue", qos: .userInteractive)

    // MARK: - Initialization

    init(tableView: UITableView,
         services: ServicesContainer,
         cellProvider: @escaping BaseCellProvider) {

        self.tableView = tableView
        self.logger = services.logger

        super.init(tableView: tableView) { [weak logger] in
            do {
                return try cellProvider($0, $1, $2)
            } catch {
                logger?.log(error: error)
                return nil
            }
        }

        configureTableView(tableView)
    }

    // MARK: - Deinitialization

    deinit {
        logger.log(deinitOf: self)
    }

    // MARK: - Public

    func bind() {}
    func configureTableView(_ tableView: UITableView) {}

    /// Returns an identifier for the first item at the specified section in the table view.
    /// - Parameter section: The section of the item in the table view.
    func itemIdentifier(for section: Int) -> SectionItem? {
        let indexPath = IndexPath(row: 0, section: section)
        return itemIdentifier(for: indexPath)
    }

}
