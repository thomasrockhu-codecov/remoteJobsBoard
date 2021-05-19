import Foundation

protocol JobDetailsCellsModel {

    var jobDetailCellJobTitle: String { get }
    var jobDetailCellDescription: String { get }
    var jobDetailCellCompanyName: String { get }
    var jobDetailCellCategory: String { get }
    var jobDetailCellPublicationDate: String { get }
    var jobDetailCellJobType: String? { get }
    var jobDetailCellLocation: String? { get }
    var jobDetailCellSalary: String? { get }

}
