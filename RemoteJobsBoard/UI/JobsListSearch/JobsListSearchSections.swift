import Foundation

struct JobsListSearchSections: DataSourceSections {

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

extension JobsListSearchSections {

	enum SectionModel: DataSourceSectionModel {

		case jobs

	}

}

// MARK: - SectionItem

extension JobsListSearchSections {

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
