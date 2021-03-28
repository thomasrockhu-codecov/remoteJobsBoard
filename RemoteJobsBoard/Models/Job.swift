import Foundation

struct Job: Hashable {

    // MARK: - Properties

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
    let type: String?

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
        type = apiModel.type
        salary = apiModel.salary
        location = apiModel.location
    }

}
