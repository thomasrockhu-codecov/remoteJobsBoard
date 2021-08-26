@testable import RemoteJobsBoard
import XCTest

final class JobsResponseModelTests: XCTestCase {

    // MARK: - Tests

    func test_decoding_full() throws {
        let jobs = try response(from: .full).jobs

        XCTAssertEqual(jobs[safe: 0]?.category, Constant.category1)
        XCTAssertEqual(jobs[safe: 0]?.companyName, Constant.companyName1)
        XCTAssertEqual(jobs[safe: 0]?.title, Constant.title1)
        XCTAssertEqual(jobs[safe: 0]?.url.absoluteString, Constant.url1)
        XCTAssertNil(jobs[safe: 0]?.salary)

        XCTAssertEqual(jobs[safe: 1]?.category, Constant.category2)
        XCTAssertEqual(jobs[safe: 1]?.companyName, Constant.companyName2)
        XCTAssertEqual(jobs[safe: 1]?.title, Constant.title2)
        XCTAssertEqual(jobs[safe: 1]?.url.absoluteString, Constant.url2)
        XCTAssertNil(jobs[safe: 1]?.salary)

        XCTAssertEqual(jobs[safe: 2]?.category, Constant.category3)
        XCTAssertEqual(jobs[safe: 2]?.companyName, Constant.companyName3)
        XCTAssertEqual(jobs[safe: 2]?.title, Constant.title3)
        XCTAssertEqual(jobs[safe: 2]?.url.absoluteString, Constant.url3)
        XCTAssertEqual(jobs[safe: 2]?.salary, Constant.salary)
    }

    func test_decoding_emptyTitle() throws {
        let jobs = try response(from: .emptyTitle).jobs

        XCTAssertEqual(jobs[safe: 0]?.category, Constant.category1)
        XCTAssertEqual(jobs[safe: 0]?.companyName, Constant.companyName1)
        XCTAssertEqual(jobs[safe: 0]?.title, Constant.title1)
        XCTAssertEqual(jobs[safe: 0]?.url.absoluteString, Constant.url1)
        XCTAssertNil(jobs[safe: 0]?.salary)

        XCTAssertEqual(jobs[safe: 1]?.category, Constant.category2)
        XCTAssertEqual(jobs[safe: 1]?.companyName, Constant.companyName2)
        XCTAssertEqual(jobs[safe: 1]?.title, Constant.title2)
        XCTAssertEqual(jobs[safe: 1]?.url.absoluteString, Constant.url2)
        XCTAssertNil(jobs[safe: 1]?.salary)

        XCTAssertNil(jobs[safe: 2])
    }

    func test_decoding_noTitle() throws {
        let jobs = try response(from: .noTitle).jobs

        XCTAssertEqual(jobs[safe: 0]?.category, Constant.category1)
        XCTAssertEqual(jobs[safe: 0]?.companyName, Constant.companyName1)
        XCTAssertEqual(jobs[safe: 0]?.title, Constant.title1)
        XCTAssertEqual(jobs[safe: 0]?.url.absoluteString, Constant.url1)
        XCTAssertNil(jobs[safe: 0]?.salary)

        XCTAssertEqual(jobs[safe: 1]?.category, Constant.category3)
        XCTAssertEqual(jobs[safe: 1]?.companyName, Constant.companyName3)
        XCTAssertEqual(jobs[safe: 1]?.title, Constant.title3)
        XCTAssertEqual(jobs[safe: 1]?.url.absoluteString, Constant.url3)
        XCTAssertEqual(jobs[safe: 1]?.salary, Constant.salary)

        XCTAssertNil(jobs[safe: 2])
    }

    func test_decoding_badTitle() throws {
        let jobs = try response(from: .badTitle).jobs

        XCTAssertEqual(jobs[safe: 0]?.category, Constant.category2)
        XCTAssertEqual(jobs[safe: 0]?.companyName, Constant.companyName2)
        XCTAssertEqual(jobs[safe: 0]?.title, Constant.title2)
        XCTAssertEqual(jobs[safe: 0]?.url.absoluteString, Constant.url2)
        XCTAssertNil(jobs[safe: 0]?.salary)

        XCTAssertEqual(jobs[safe: 1]?.category, Constant.category3)
        XCTAssertEqual(jobs[safe: 1]?.companyName, Constant.companyName3)
        XCTAssertEqual(jobs[safe: 1]?.title, Constant.title3)
        XCTAssertEqual(jobs[safe: 1]?.url.absoluteString, Constant.url3)
        XCTAssertEqual(jobs[safe: 1]?.salary, Constant.salary)

        XCTAssertNil(jobs[safe: 2])
    }

    func test_decoding_emptyURL() throws {
        let jobs = try response(from: .emptyURL).jobs

        XCTAssertEqual(jobs[safe: 0]?.category, Constant.category1)
        XCTAssertEqual(jobs[safe: 0]?.companyName, Constant.companyName1)
        XCTAssertEqual(jobs[safe: 0]?.title, Constant.title1)
        XCTAssertEqual(jobs[safe: 0]?.url.absoluteString, Constant.url1)
        XCTAssertNil(jobs[safe: 0]?.salary)

        XCTAssertEqual(jobs[safe: 1]?.category, Constant.category3)
        XCTAssertEqual(jobs[safe: 1]?.companyName, Constant.companyName3)
        XCTAssertEqual(jobs[safe: 1]?.title, Constant.title3)
        XCTAssertEqual(jobs[safe: 1]?.url.absoluteString, Constant.url3)
        XCTAssertEqual(jobs[safe: 1]?.salary, Constant.salary)

        XCTAssertNil(jobs[safe: 2])
    }

    func test_decoding_noURL() throws {
        let jobs = try response(from: .noURL).jobs

        XCTAssertEqual(jobs[safe: 0]?.category, Constant.category2)
        XCTAssertEqual(jobs[safe: 0]?.companyName, Constant.companyName2)
        XCTAssertEqual(jobs[safe: 0]?.title, Constant.title2)
        XCTAssertEqual(jobs[safe: 0]?.url.absoluteString, Constant.url2)
        XCTAssertNil(jobs[safe: 0]?.salary)

        XCTAssertEqual(jobs[safe: 1]?.category, Constant.category3)
        XCTAssertEqual(jobs[safe: 1]?.companyName, Constant.companyName3)
        XCTAssertEqual(jobs[safe: 1]?.title, Constant.title3)
        XCTAssertEqual(jobs[safe: 1]?.url.absoluteString, Constant.url3)
        XCTAssertEqual(jobs[safe: 1]?.salary, Constant.salary)

        XCTAssertNil(jobs[safe: 2])
    }

    func test_decoding_badURL_1() throws {
        let jobs = try response(from: .badURL1).jobs

        XCTAssertEqual(jobs[safe: 0]?.category, Constant.category2)
        XCTAssertEqual(jobs[safe: 0]?.companyName, Constant.companyName2)
        XCTAssertEqual(jobs[safe: 0]?.title, Constant.title2)
        XCTAssertEqual(jobs[safe: 0]?.url.absoluteString, Constant.url2)
        XCTAssertNil(jobs[safe: 0]?.salary)

        XCTAssertEqual(jobs[safe: 1]?.category, Constant.category3)
        XCTAssertEqual(jobs[safe: 1]?.companyName, Constant.companyName3)
        XCTAssertEqual(jobs[safe: 1]?.title, Constant.title3)
        XCTAssertEqual(jobs[safe: 1]?.url.absoluteString, Constant.url3)
        XCTAssertEqual(jobs[safe: 1]?.salary, Constant.salary)

        XCTAssertNil(jobs[safe: 2])
    }

    func test_decoding_badURL_2() throws {
        let jobs = try response(from: .badURL2).jobs

        XCTAssertEqual(jobs[safe: 0]?.category, Constant.category2)
        XCTAssertEqual(jobs[safe: 0]?.companyName, Constant.companyName2)
        XCTAssertEqual(jobs[safe: 0]?.title, Constant.title2)
        XCTAssertEqual(jobs[safe: 0]?.url.absoluteString, Constant.url2)
        XCTAssertNil(jobs[safe: 0]?.salary)

        XCTAssertEqual(jobs[safe: 1]?.category, Constant.category3)
        XCTAssertEqual(jobs[safe: 1]?.companyName, Constant.companyName3)
        XCTAssertEqual(jobs[safe: 1]?.title, Constant.title3)
        XCTAssertEqual(jobs[safe: 1]?.url.absoluteString, Constant.url3)
        XCTAssertEqual(jobs[safe: 1]?.salary, Constant.salary)

        XCTAssertNil(jobs[safe: 2])
    }

}

// MARK: - Helpers

private extension JobsResponseModelTests {

    func response(from json: MockJSON) throws -> APIService.JobsResponseModel {
        let jsonData = try MockJSONLoader.loadJSON(named: json.fileName)
        return try JSONDecoder().decode(APIService.JobsResponseModel.self, from: jsonData)
    }

}

// MARK: - Constants

private extension JobsResponseModelTests {

    enum Constant {

        static let category1 = "All others"
        static let category2 = "Writing"
        static let category3 = "QA"

        static let companyName1 = "Rocketbook"
        static let companyName2 = "Postclick"
        static let companyName3 = "Zego"

        static let title1 = "Supply Chain Coordinator"
        static let title2 = "Copywriter"
        static let title3 = "QA Engineer"

        static let url1 = "https://remotive.io/remote-jobs/all-others/supply-chain-coordinator-515247"
        static let url2 = "https://remotive.io/remote-jobs/writing/copywriter-543382"
        static let url3 = "https://remotive.io/remote-jobs/qa/qa-engineer-515938"

        static let salary = "140,000-150,000 per year"

    }

}
