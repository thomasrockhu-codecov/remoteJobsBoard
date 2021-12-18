import Foundation

struct Job: Hashable {

	// MARK: - Properties

	private static let publicationDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.doesRelativeDateFormatting = true
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()

	/// Job category.
	let category: String

	/// Job title.
	let title: String

	/// Job listing detail url.
	let url: URL

	/// Name of the company which is hiring.
	let companyName: String

	/// Publication date and time on https://remotive.io.
	let publicationDate: Date

	/// The full HTML job description.
	let description: String

	/// Job type.
	let type: JobType?

	/// Salary description, usually a yearly salary range, in USD.
	let salary: String?

	/// Geographical restriction for the remote candidate, if any.
	let location: String?

	// MARK: - Initialization

	init(apiModel: APIService.JobsResponseModel.Job) {
		category = apiModel.category
		title = apiModel.title
		url = apiModel.url
		companyName = apiModel.companyName
		publicationDate = apiModel.publicationDate
		description = apiModel.description
		type = JobType(rawValue: apiModel.type)
		salary = apiModel.salary
		location = apiModel.location
	}

}

// MARK: - JobsListRecentJobCellModel

extension Job: JobsListRecentJobCellModel {

	var recentJobCellJobTitle: String { title }
	var recentJobCellCompanyName: String { companyName }
	var recentJobCellPublicationDate: String { Self.publicationDateFormatter.string(from: publicationDate) }

}

// MARK: - JobDetailsCellsModel

extension Job: JobDetailsCellsModel {

	var jobDetailCellJobTitle: String { title }
	var jobDetailCellDescription: String { description }
	var jobDetailCellCompanyName: String { companyName }
	var jobDetailCellCategory: String { category }
	var jobDetailCellPublicationDate: String { Self.publicationDateFormatter.string(from: publicationDate) }
	var jobDetailCellJobType: String? { type?.localizedTitle }
	var jobDetailCellLocation: String? { location }
	var jobDetailCellSalary: String? { salary }

}

// MARK: - Job Type

extension Job {

	enum JobType {

		case fullTime
		case contract

		var localizedTitle: String {
			switch self {
			case .contract:
				return LocalizedString.JobType.contract
			case .fullTime:
				return LocalizedString.JobType.fullTime
			}
		}

		init?(rawValue: String?) {
			switch rawValue {
			case "full_time":
				self = .fullTime
			case "contract":
				self = .contract
			default:
				return nil
			}
		}

	}

}
