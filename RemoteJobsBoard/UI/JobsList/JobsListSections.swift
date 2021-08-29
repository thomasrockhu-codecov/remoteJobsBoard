import Foundation

struct JobsListSections: DataSourceSections {

    // MARK: - Properties

    let sections: [Section]

    // MARK: - Initialization

    init(jobs: [Job]) {
        sections = [Self.jobsSection(jobs: jobs)]
    }

    // MARK: - Public Methods

    static func jobsSection(jobs: [Job]) -> Section {
        let items = jobs.map { SectionItem.job($0) }
        return (.jobs, items)
    }

}

// MARK: - SectionModel

extension JobsListSections {

    enum SectionModel: DataSourceSectionModel {

        case jobs

    }

}

// MARK: - SectionItem

extension JobsListSections {

    enum SectionItem: DataSourceSectionItem {

        case job(Job)

        var section: SectionModel {
            switch self {
            case .job:
                return .jobs
            }
        }

    }

}
