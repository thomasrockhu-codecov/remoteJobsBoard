import Foundation

extension JobsList {

	struct Sections: DataSourceSections {

		// MARK: - Properties

		let sections: [Section]

		// MARK: - Initialization

		init(categories: [Job.Category], jobs: [Job]) {
			sections = [
				Self.categoriesSection(categories: categories),
				Self.jobsSection(jobs: jobs)
			]
		}

		// MARK: - Public Methods

		static func categoriesSection(categories: [Job.Category]) -> Section {
			let items = categories.map { SectionItem.category($0) }
			return (.categories, items)
		}

		static func jobsSection(jobs: [Job]) -> Section {
			let items = jobs.map { SectionItem.job($0) }
			return (.jobs, items)
		}

	}

}

// MARK: - SectionModel

extension JobsList.Sections {

	enum SectionModel: DataSourceSectionModel {

		case categories
		case jobs

	}

}

// MARK: - SectionItem

extension JobsList.Sections {

	enum SectionItem: DataSourceSectionItem {

		case job(Job)
		case category(Job.Category)

		var section: SectionModel {
			switch self {
			case .job:
				return .jobs
			case .category:
				return .categories
			}
		}

	}

}

// MARK: - Constants

extension JobsList.Sections {

	enum Constant {

		static let jobsSectionIndex = 1

	}

}
