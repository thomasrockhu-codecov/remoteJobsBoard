import UIKit

public protocol DataSourceSections {

    associatedtype SectionModel: DataSourceSectionModel
    associatedtype SectionItem: DataSourceSectionItem

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionModel, SectionItem>
    typealias Section = (section: SectionModel, items: [SectionItem])

    var sections: [Section] { get }

}

public extension DataSourceSections {

    var snapshot: DataSourceSnapshot {
        var snapshot = DataSourceSnapshot()
        sections.forEach {
            snapshot.appendSections([$0.section])
            snapshot.appendItems($0.items, toSection: $0.section)
        }
        return snapshot
    }

}
