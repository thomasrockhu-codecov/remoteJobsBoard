@testable import RemoteJobsBoard
import XCTest

final class JobDetailsSectionsTests: XCTestCase {

    // MARK: - Typealiases

    fileprivate typealias SectionItem = JobDetailsSections.SectionItem

    // MARK: - Tests

    func test_descriptionSection() {
        let job = MockJob()
        let items = JobDetailsSections.descriptionSection(job: job).items
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[safe: 0], .description(Constant.description))
    }

    func test_sectionItem_section() {
        XCTAssertEqual(SectionItem.category(Constant.category).section, .headline)
        XCTAssertEqual(SectionItem.companyName(Constant.companyName).section, .headline)
        XCTAssertEqual(SectionItem.description(Constant.description).section, .description)
        XCTAssertEqual(SectionItem.jobTitle(Constant.jobTitle).section, .headline)
        XCTAssertEqual(SectionItem.location(Constant.location).section, .headline)
        XCTAssertEqual(SectionItem.publicationDate(Constant.publicationDate).section, .headline)
        XCTAssertEqual(SectionItem.terms(salary: Constant.salary, jobType: Constant.jobType).section, .headline)
    }

    func test_sectionItem_init() {
        XCTAssertEqual(
            SectionItem(category: Constant.category),
            .category(Constant.category)
        )
        XCTAssertEqual(
            SectionItem(companyName: Constant.companyName),
            .companyName(Constant.companyName)
        )
        XCTAssertEqual(
            SectionItem(description: Constant.description),
            .description(Constant.description)
        )
        XCTAssertEqual(
            SectionItem(jobTitle: Constant.jobTitle),
            .jobTitle(Constant.jobTitle)
        )
        XCTAssertEqual(
            SectionItem(location: Constant.location),
            .location(Constant.location)
        )
        XCTAssertEqual(
            SectionItem(publicationDate: Constant.publicationDate),
            .publicationDate(Constant.publicationDate)
        )
        XCTAssertEqual(
            SectionItem(salary: Constant.salary, jobType: Constant.jobType),
            .terms(salary: Constant.salary, jobType: Constant.jobType)
        )
        XCTAssertEqual(
            SectionItem(salary: Constant.salary, jobType: nil),
            .terms(salary: Constant.salary, jobType: nil)
        )
        XCTAssertEqual(
            SectionItem(salary: nil, jobType: Constant.jobType),
            .terms(salary: nil, jobType: Constant.jobType)
        )
        XCTAssertNil(SectionItem(salary: nil, jobType: nil))
        XCTAssertNil(SectionItem(location: nil))
    }

    // MARK: - Tests - Headline Section

    func test_headlineSection_full() {
        let job = MockJob()
        let items = JobDetailsSections.headlineSection(job: job).items
        XCTAssertEqual(items.count, 6)
        XCTAssertEqual(items[safe: 0], .publicationDate(Constant.publicationDate))
        XCTAssertEqual(items[safe: 1], .category(Constant.category))
        XCTAssertEqual(items[safe: 2], .jobTitle(Constant.jobTitle))
        XCTAssertEqual(items[safe: 3], .companyName(Constant.companyName))
        XCTAssertEqual(items[safe: 4], .location(Constant.location))
        XCTAssertEqual(items[safe: 5], .terms(salary: Constant.salary, jobType: Constant.jobType))
    }

    func test_headlineSection_nilLocation() {
        let job = MockJob(location: nil)
        let items = JobDetailsSections.headlineSection(job: job).items
        XCTAssertEqual(items.count, 5)
        XCTAssertEqual(items[safe: 0], .publicationDate(Constant.publicationDate))
        XCTAssertEqual(items[safe: 1], .category(Constant.category))
        XCTAssertEqual(items[safe: 2], .jobTitle(Constant.jobTitle))
        XCTAssertEqual(items[safe: 3], .companyName(Constant.companyName))
        XCTAssertEqual(items[safe: 4], .terms(salary: Constant.salary, jobType: Constant.jobType))
    }

    func test_headlineSection_nilType() {
        let job = MockJob(jobType: nil)
        let items = JobDetailsSections.headlineSection(job: job).items
        XCTAssertEqual(items.count, 6)
        XCTAssertEqual(items[safe: 0], .publicationDate(Constant.publicationDate))
        XCTAssertEqual(items[safe: 1], .category(Constant.category))
        XCTAssertEqual(items[safe: 2], .jobTitle(Constant.jobTitle))
        XCTAssertEqual(items[safe: 3], .companyName(Constant.companyName))
        XCTAssertEqual(items[safe: 4], .location(Constant.location))
        XCTAssertEqual(items[safe: 5], .terms(salary: Constant.salary, jobType: nil))
    }

    func test_headlineSection_nilSalary() {
        let job = MockJob(salary: nil)
        let items = JobDetailsSections.headlineSection(job: job).items
        XCTAssertEqual(items.count, 6)
        XCTAssertEqual(items[safe: 0], .publicationDate(Constant.publicationDate))
        XCTAssertEqual(items[safe: 1], .category(Constant.category))
        XCTAssertEqual(items[safe: 2], .jobTitle(Constant.jobTitle))
        XCTAssertEqual(items[safe: 3], .companyName(Constant.companyName))
        XCTAssertEqual(items[safe: 4], .location(Constant.location))
        XCTAssertEqual(items[safe: 5], .terms(salary: nil, jobType: Constant.jobType))
    }

    func test_headlineSection_nilTypeSalary() {
        let job = MockJob(jobType: nil, salary: nil)
        let items = JobDetailsSections.headlineSection(job: job).items
        XCTAssertEqual(items.count, 5)
        XCTAssertEqual(items[safe: 0], .publicationDate(Constant.publicationDate))
        XCTAssertEqual(items[safe: 1], .category(Constant.category))
        XCTAssertEqual(items[safe: 2], .jobTitle(Constant.jobTitle))
        XCTAssertEqual(items[safe: 3], .companyName(Constant.companyName))
        XCTAssertEqual(items[safe: 4], .location(Constant.location))
    }

    func test_headlineSection_nilTypeLocationSalary() {
        let job = MockJob(jobType: nil, location: nil, salary: nil)
        let items = JobDetailsSections.headlineSection(job: job).items
        XCTAssertEqual(items.count, 4)
        XCTAssertEqual(items[safe: 0], .publicationDate(Constant.publicationDate))
        XCTAssertEqual(items[safe: 1], .category(Constant.category))
        XCTAssertEqual(items[safe: 2], .jobTitle(Constant.jobTitle))
        XCTAssertEqual(items[safe: 3], .companyName(Constant.companyName))
    }

}

// MARK: - Constants

private extension JobDetailsSectionsTests {

    enum Constant {

        static let jobTitle = "QA Engineer"
        static let companyName = "Zego"
        static let category = "QA"
        static let publicationDate = "Today"
        static let jobType = "Full-Time"
        static let location = "Anywhere"
        static let salary = "140,000-150,000 per year"
        static let description = "We are Zego, a global insurtech scale-up providing cover that creates possibilities"

    }

}

// MARK: - MockJob

private extension JobDetailsSectionsTests {

    struct MockJob: JobDetailsCellsModel {

        let jobDetailCellJobTitle: String = Constant.jobTitle
        let jobDetailCellDescription: String = Constant.description
        let jobDetailCellCompanyName: String = Constant.companyName
        let jobDetailCellCategory: String = Constant.category
        let jobDetailCellPublicationDate: String = Constant.publicationDate

        let jobDetailCellJobType: String?
        let jobDetailCellLocation: String?
        let jobDetailCellSalary: String?

        init(jobType: String? = Constant.jobType,
             location: String? = Constant.location,
             salary: String? = Constant.salary) {

            jobDetailCellJobType = jobType
            jobDetailCellLocation = location
            jobDetailCellSalary = salary
        }

    }

}
