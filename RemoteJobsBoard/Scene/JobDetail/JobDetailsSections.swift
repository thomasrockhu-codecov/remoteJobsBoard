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
            SectionItem(publicationDate: job.jobDetailCellPublicationDate),
            SectionItem(category: job.jobDetailCellCategory),
            SectionItem(jobTitle: job.jobDetailCellJobTitle),
            SectionItem(companyName: job.jobDetailCellCompanyName),
            SectionItem(location: job.jobDetailCellLocation),
            SectionItem(salary: job.jobDetailCellSalary, jobType: job.jobDetailCellJobType)
        ]
        .compactMap { $0 }
        return (.headline, items)
    }

    static func descriptionSection(job: JobDetailsCellsModel) -> Section {
        let items = [SectionItem.description(job.jobDetailCellDescription)]
        return (.description, items)
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

        init(jobTitle: String) {
            self = .jobTitle(jobTitle)
        }

        init(description: String) {
            self = .description(description)
        }

        init(companyName: String) {
            self = .companyName(companyName)
        }

        init(category: String) {
            self = .category(category)
        }

        init(publicationDate: String) {
            self = .publicationDate(publicationDate)
        }

        init?(location: String?) {
            guard let location = location else { return nil }
            self =  .location(location)
        }

        init?(salary: String?, jobType: String?) {
            if jobType == nil, salary == nil { return nil }
            self = .terms(salary: salary, jobType: jobType)
        }

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
