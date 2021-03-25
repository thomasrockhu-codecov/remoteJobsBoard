import Foundation

public protocol DataSourceSectionItem: Hashable {

    associatedtype SectionModel = DataSourceSectionModel

    var section: SectionModel { get }

}
