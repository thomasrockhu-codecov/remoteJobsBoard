import Foundation

protocol JobDetailsCellsModel {

    // TODO: Add publicationDate and type

    var jobDetailCellJobTitle: String { get }
    var jobDetailCellLocation: String? { get }
    var jobDetailCellSalary: String? { get }
    var jobDetailCellDescription: String { get }
    var jobDetailCellCompanyName: String { get }
    var jobDetailCellCategory: String { get }

}
