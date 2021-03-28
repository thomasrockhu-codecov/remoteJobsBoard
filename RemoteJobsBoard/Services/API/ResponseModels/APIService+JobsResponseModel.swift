import Foundation

// swiftlint:disable nesting
extension APIService {

    struct JobsResponseModel: Decodable {

        enum CodingKeys: String, CodingKey {
            case jobs
        }

        /// The list of all jobs retrieved.
        let jobs: [Job]

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            jobs = try container.decodeCollectionSafely(forKey: .jobs)
        }

    }

}

// MARK: - Job

extension APIService.JobsResponseModel {

    struct Job: Decodable {

        enum CodingKeys: String, CodingKey {
            case title
            case salary
            case url
            case category
            case description
            case location = "candidate_required_location"
            case publicationDate = "publication_date"
            case type = "job_type"
            case companyName = "company_name"
        }

        /// Job category.
        let category: String

        /// Job title.
        let title: String

        /// Job listing detail url.
        let url: URL

        /// Name of the company which is hiring.
        let companyName: String

        /// The full HTML job description.
        let description: String

        /// Publication date and time on https://remotive.io.
        let publicationDate: Date

        /// Geographical restriction for the remote candidate, if any.
        let location: String?

        /// Job type.
        let type: String?

        /// Salary description, usually a yearly salary range, in USD.
        let salary: String?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            title = try container.decodeNotEmptyString(forKey: .title)
            url = try container.decode(URL.self, forKey: .url)
            companyName = try container.decodeNotEmptyString(forKey: .companyName)
            category = try container.decodeNotEmptyString(forKey: .category)
            description = try container.decodeNotEmptyString(forKey: .description)
            publicationDate = try container.decodeDate(forKey: .publicationDate)
            salary = try? container.decodeNotEmptyStringIfPresent(forKey: .salary)
            type = try? container.decodeNotEmptyStringIfPresent(forKey: .type)
            location = try? container.decodeNotEmptyStringIfPresent(forKey: .location)
        }

    }

}
// swiftlint:enable nesting
