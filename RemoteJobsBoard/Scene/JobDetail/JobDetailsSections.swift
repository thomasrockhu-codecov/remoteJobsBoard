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
        let items: [SectionItem] = [
            .publicationDate(job.jobDetailCellPublicationDate),
            .category(job.jobDetailCellCategory),
            .jobTitle(job.jobDetailCellJobTitle),
            .companyName(job.jobDetailCellCompanyName),
            locationItem(job: job),
            termsItem(job: job)
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

    static func termsItem(job: JobDetailsCellsModel) -> SectionItem? {
        if job.jobDetailCellJobType == nil, job.jobDetailCellLocation == nil { return nil }
        return .terms(salary: job.jobDetailCellSalary, jobType: job.jobDetailCellJobType)
    }

    static func locationItem(job: JobDetailsCellsModel) -> SectionItem? {
        guard let location = job.jobDetailCellLocation else { return nil }
        return .location(location)
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
        case terms(salary: String?, jobType: String?)
        case location(String)
        case description(String)
        case companyName(String)
        case category(String)
        case publicationDate(String)

        var section: SectionModel {
            switch self {
            case .description:
                return .description
            default:
                return .headline
            }
        }

    }

}
