@testable import RemoteJobsBoard
import XCTest

final class LocalizedStringTests: XCTestCase {

    // MARK: - Tests

    func test_navigationTitle() throws {
        try check(
            LocalizedString.NavigationTitle.jobsList,
            englishString: "Remote Jobs Board"
        )
    }

    func test_jobType() throws {
        try check(
            LocalizedString.JobType.contract,
            englishString: "Contract"
        )
        try check(
            LocalizedString.JobType.fullTime,
            englishString: "Full-Time"
        )
    }

    func test_jobDetails() throws {
        try check(
            LocalizedString.JobDetails.applyButtonTitle,
            englishString: "Apply"
        )
    }

}

// MARK: - Helpers

private extension LocalizedStringTests {

    func check(_ localizedString: String,
               englishString: String) throws {

        switch Locale.current.languageCode {
        case .none:
            throw TestError.nilLanguageCode
        case "en":
            if localizedString != englishString { throw TestError.wrongEnglishString }
        default:
            if localizedString != englishString { throw TestError.wrongNewLanguageString }
        }
    }

}

// MARK: - Test Error

private extension LocalizedStringTests {

    enum TestError: Error {

        case nilLanguageCode
        case wrongNewLanguageString
        case wrongEnglishString

    }

}
