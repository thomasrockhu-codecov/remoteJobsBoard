@testable import RemoteJobsBoard
import XCTest

final class JobDetailsSectionsTests: XCTestCase {

	// MARK: - Typealiases

	fileprivate typealias Sections = JobDetails.Sections
	fileprivate typealias SectionItem = Sections.SectionItem

	// MARK: - Tests

	func test_descriptionSection() {
		let job = MockJob()
		let items = Sections.descriptionSection(job: job).items
		XCTAssertEqual(items.count, 1)
		XCTAssertEqual(items[safe: 0], .description(Constant.description))
	}

	func test_headlineSection() {
		let job = MockJob()
		let items = Sections.headlineSection(job: job).items
		XCTAssertEqual(items.count, 2)
		XCTAssertEqual(items[safe: 0], .jobTitle(Constant.jobTitle))
		XCTAssertEqual(items[safe: 1], .companyName(Constant.companyName))
	}

	func test_sectionItem_section() {
		XCTAssertEqual(SectionItem.companyName(Constant.companyName).section, .headline)
		XCTAssertEqual(SectionItem.description(Constant.description).section, .description)
		XCTAssertEqual(SectionItem.jobTitle(Constant.jobTitle).section, .headline)
		XCTAssertEqual(SectionItem.tag(Constant.jobType).section, .tags)
	}

	func test_sectionItem_init() {
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
			SectionItem(tag: Constant.jobType),
			.tag(Constant.jobType)
		)
	}

	// MARK: - Tests - Tags Section

	func test_tagsSection_full() {
		let job = MockJob()
		let items = Sections.tagsSection(job: job)?.items
		XCTAssertEqual(items?.count, 5)
		XCTAssertEqual(items?[safe: 0], .tag(Constant.category))
		XCTAssertEqual(items?[safe: 1], .tag(Constant.jobType))
		XCTAssertEqual(items?[safe: 2], .tag(Constant.salary))
		XCTAssertEqual(items?[safe: 3], .tag(Constant.location))
		XCTAssertEqual(items?[safe: 4], .tag(Constant.publicationDate))
	}

	func test_tagsSection_nilJobType() {
		let job = MockJob(jobType: nil)
		let items = Sections.tagsSection(job: job)?.items
		XCTAssertEqual(items?.count, 4)
		XCTAssertEqual(items?[safe: 0], .tag(Constant.category))
		XCTAssertEqual(items?[safe: 1], .tag(Constant.salary))
		XCTAssertEqual(items?[safe: 2], .tag(Constant.location))
		XCTAssertEqual(items?[safe: 3], .tag(Constant.publicationDate))
	}

	func test_tagsSection_nilSalary() {
		let job = MockJob(salary: nil)
		let items = Sections.tagsSection(job: job)?.items
		XCTAssertEqual(items?.count, 4)
		XCTAssertEqual(items?[safe: 0], .tag(Constant.category))
		XCTAssertEqual(items?[safe: 1], .tag(Constant.jobType))
		XCTAssertEqual(items?[safe: 2], .tag(Constant.location))
		XCTAssertEqual(items?[safe: 3], .tag(Constant.publicationDate))
	}

	func test_tagsSection_nilLocation() {
		let job = MockJob(location: nil)
		let items = Sections.tagsSection(job: job)?.items
		XCTAssertEqual(items?.count, 4)
		XCTAssertEqual(items?[safe: 0], .tag(Constant.category))
		XCTAssertEqual(items?[safe: 1], .tag(Constant.jobType))
		XCTAssertEqual(items?[safe: 2], .tag(Constant.salary))
		XCTAssertEqual(items?[safe: 3], .tag(Constant.publicationDate))
	}

	func test_tagsSection_nilTags() {
		let job = MockJob2()
		XCTAssertNil(Sections.tagsSection(job: job)?.items)
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

// MARK: - MockJob2

private extension JobDetailsSectionsTests {

	struct MockJob2: JobDetailsCellsModel {

		let jobDetailCellJobTitle: String = Constant.jobTitle
		let jobDetailCellDescription: String = Constant.description
		let jobDetailCellCompanyName: String = Constant.companyName
		let jobDetailCellCategory: String = Constant.category
		let jobDetailCellPublicationDate: String = Constant.publicationDate
		let jobDetailCellJobType: String? = Constant.jobType
		let jobDetailCellLocation: String? = Constant.location
		let jobDetailCellSalary: String? = Constant.salary

		let jobDetailCellTags: [String]? = nil

	}

}
