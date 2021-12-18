import Foundation

struct JobDetailsSections: DataSourceSections {

	// MARK: - Properties

	let sections: [Section]

	// MARK: - Initialization

	init(job: JobDetailsCellsModel) {
		sections = [
			Self.headlineSection(job: job),
			Self.tagsSection(job: job),
			Self.descriptionSection(job: job)
		]
		.compactMap { $0 }
	}

	// MARK: - Public Methods

	static func headlineSection(job: JobDetailsCellsModel) -> Section {
		let items = [
			SectionItem(jobTitle: job.jobDetailCellJobTitle),
			SectionItem(companyName: job.jobDetailCellCompanyName)
		]
		.compactMap { $0 }
		return (.headline, items)
	}

	static func tagsSection(job: JobDetailsCellsModel) -> Section? {
		guard let tags = job.jobDetailCellTags else { return nil }
		let items = tags.map { SectionItem.tag($0) }
		return (.tags, items)
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
		case tags

	}

}

// MARK: - SectionItem

extension JobDetailsSections {

	enum SectionItem: DataSourceSectionItem {

		case jobTitle(String)
		case description(String)
		case companyName(String)
		case tag(String)

		init(tag: String) {
			self = .tag(tag)
		}

		init(jobTitle: String) {
			self = .jobTitle(jobTitle)
		}

		init(description: String) {
			self = .description(description)
		}

		init(companyName: String) {
			self = .companyName(companyName)
		}

		var section: SectionModel {
			switch self {
			case .description:
				return .description
			case .tag:
				return .tags
			default:
				return .headline
			}
		}

	}

}
