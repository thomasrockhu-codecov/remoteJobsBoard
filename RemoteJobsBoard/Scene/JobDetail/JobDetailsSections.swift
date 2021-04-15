import Foundation

struct JobDetailsSections: DataSourceSections {

    // MARK: - Properties

    let sections: [Section]

    // MARK: - Initialization

    init(job: JobDetailsCellsModel) {
        sections = [
            Self.headlineSection(job: job),
            Self.descriptionSection(job: job)
        ]
    }

    // MARK: - Public Methods

    static func headlineSection(job: JobDetailsCellsModel) -> Section {
        let items = [
            SectionItem.jobTitle(job.jobDetailCellJobTitle),
            locationSalaryItem(job: job)
        ]
        .compactMap { $0 }
        return (.headline, items)
    }

    static func descriptionSection(job: JobDetailsCellsModel) -> Section {
        let items = [SectionItem.description(job.jobDetailCellDescription)]
        return (.description, items)
    }

}

// MARK: - Private Methods

private extension JobDetailsSections {

    static func locationSalaryItem(job: JobDetailsCellsModel) -> SectionItem? {
        if job.jobDetailCellLocation == nil && job.jobDetailCellSalary == nil {
            return nil
        }
        return .locationSalary(location: job.jobDetailCellLocation, salary: job.jobDetailCellSalary)
    }

}

// MARK: - SectionModel

extension JobDetailsSections {

    enum SectionModel: DataSourceSectionModel {

        case headline
        case description

    }

}

// MARK: - SectionItem

extension JobDetailsSections {

    enum SectionItem: DataSourceSectionItem {

        case jobTitle(String)
        case locationSalary(location: String?, salary: String?)
        case description(String)

        var section: SectionModel {
            switch self {
            case .jobTitle, .locationSalary:
                return .headline
            case .description:
                return .description
            }
        }

    }

}
