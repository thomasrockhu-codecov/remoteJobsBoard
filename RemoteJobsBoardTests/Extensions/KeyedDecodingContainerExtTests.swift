@testable import RemoteJobsBoard
import XCTest

final class KeyedDecodingContainerExtTests: XCTestCase {

    // MARK: - Properties

    private let decoder = JSONDecoder()

    // MARK: - Tests - Decode Collection Safely

    func test_decodeCollectionSafely_success() throws {
        let decoded = try Self.decode(type: DecodeCollectionSafely.self, from: Constant.collectionJSON1)

        XCTAssertEqual(decoded.array.count, Constant.collectionJSON1Count)
    }

    func test_decodeCollectionSafely_partialSuccess() throws {
        let decoded = try Self.decode(type: DecodeCollectionSafely.self, from: Constant.collectionJSON2)

        XCTAssertEqual(decoded.array.count, Constant.collectionJSON2Count)
    }

    func test_decodeCollectionSafely_fail() {
        XCTAssertThrowsError(try Self.decode(type: DecodeCollectionSafely.self, from: Constant.collectionWrongJSON1))
        XCTAssertThrowsError(try Self.decode(type: DecodeCollectionSafely.self, from: Constant.collectionWrongJSON2))
    }

    // MARK: - Tests - Decode Collection Safely If Present

    func test_decodeCollectionSafelyIfPresent_success() throws {
        let decoded = try Self.decode(type: DecodeCollectionSafelyIfPresent.self, from: Constant.collectionJSON1)

        XCTAssertEqual(decoded.array.count, Constant.collectionJSON1Count)
    }

    func test_decodeCollectionSafelyIfPresent_partialSuccess() throws {
        let decoded = try Self.decode(type: DecodeCollectionSafelyIfPresent.self, from: Constant.collectionJSON2)

        XCTAssertEqual(decoded.array.count, Constant.collectionJSON2Count)
    }

    // swiftlint:disable line_length
    func test_decodeCollectionSafelyIfPresent_fail() throws {
        XCTAssertThrowsError(try Self.decode(type: DecodeCollectionSafelyIfPresent.self, from: Constant.collectionWrongJSON1))
        XCTAssertTrue(try Self.decode(type: DecodeCollectionSafelyIfPresent.self, from: Constant.collectionWrongJSON2).array.isEmpty)
    }
    // swiftlint:enable line_length

    // MARK: - Tests - Decode Not Empty String

    func test_decodeNotEmptyString_success() throws {
        let decoded = try Self.decode(type: DecodeNotEmptyString.self, from: Constant.stringJSON1)

        XCTAssertEqual(decoded.firstString, Constant.stringJSONFirstString)
        XCTAssertEqual(decoded.secondString, Constant.stringJSONSecondString)
        XCTAssertEqual(decoded.thirdString, Constant.stringJSONThirdString)
    }

    func test_decodeNotEmptyString_fail() {
        XCTAssertThrowsError(try Self.decode(type: DecodeNotEmptyString.self, from: Constant.stringWrongJSON1))
        XCTAssertThrowsError(try Self.decode(type: DecodeNotEmptyString.self, from: Constant.stringWrongJSON2))
        XCTAssertThrowsError(try Self.decode(type: DecodeNotEmptyString.self, from: Constant.stringWrongJSON3))
        XCTAssertThrowsError(try Self.decode(type: DecodeNotEmptyString.self, from: Constant.stringWrongJSON4))
    }

    // MARK: - Tests - Decode Not Empty String If Present

    func test_decodeNotEmptyStringIfPresent_success() throws {
        let decoded = try Self.decode(type: DecodeNotEmptyStringIfPresent.self, from: Constant.stringJSON1)

        XCTAssertEqual(decoded.firstString, Constant.stringJSONFirstString)
        XCTAssertEqual(decoded.secondString, Constant.stringJSONSecondString)
        XCTAssertEqual(decoded.thirdString, Constant.stringJSONThirdString)
    }

    func test_decodeNotEmptyStringIfPresent_partialSuccess() throws {
        let decoded = try Self.decode(type: DecodeNotEmptyStringIfPresent.self, from: Constant.stringWrongJSON1)

        XCTAssertEqual(decoded.firstString, Constant.stringJSONFirstString)
        XCTAssertEqual(decoded.secondString, Constant.stringJSONSecondString)
        XCTAssertNil(decoded.thirdString)
    }

    func test_decodeNotEmptyStringIfPresent_fail() {
        XCTAssertThrowsError(try Self.decode(type: DecodeNotEmptyStringIfPresent.self, from: Constant.stringWrongJSON2))
        XCTAssertThrowsError(try Self.decode(type: DecodeNotEmptyStringIfPresent.self, from: Constant.stringWrongJSON3))
        XCTAssertThrowsError(try Self.decode(type: DecodeNotEmptyStringIfPresent.self, from: Constant.stringWrongJSON4))
    }

    // MARK: - Tests - Decode ISO8601 Date

    func test_decodeISO8601Date_success() throws {
        let decoded = try Self.decode(type: DecodeISO8601Date.self, from: Constant.dateJSON1)

        XCTAssertEqual(decoded.firstDate, Constant.dateJSONFirstDate)
        XCTAssertEqual(decoded.secondDate, Constant.dateJSONSecondDate)
    }

    func test_decodeISO8601Date_fail() {
        XCTAssertThrowsError(try Self.decode(type: DecodeISO8601Date.self, from: Constant.dateWrongJSON1))
        XCTAssertThrowsError(try Self.decode(type: DecodeISO8601Date.self, from: Constant.dateWrongJSON2))
    }

    // MARK: - Tests - Decode ISO8601 Date If Present

    func test_decodeISO8601DateIfPresent_success() throws {
        let decoded = try Self.decode(type: DecodeISO8601DateIfPresent.self, from: Constant.dateJSON1)

        XCTAssertEqual(decoded.firstDate, Constant.dateJSONFirstDate)
        XCTAssertEqual(decoded.secondDate, Constant.dateJSONSecondDate)
    }

    func test_decodeISO8601DateIfPresent_partialSuccess() throws {
        let decoded = try Self.decode(type: DecodeISO8601DateIfPresent.self, from: Constant.dateWrongJSON1)

        XCTAssertEqual(decoded.firstDate, Constant.dateJSONFirstDate)
        XCTAssertNil(decoded.secondDate)
    }

    func test_decodeISO8601DateIfPresent_fail() {
        XCTAssertThrowsError(try Self.decode(type: DecodeISO8601DateIfPresent.self, from: Constant.dateWrongJSON2))
    }

    // MARK: - Tests - Decode Date

    func test_decodeDate_success() throws {
        let decoded = try Self.decode(type: DecodeDate.self, from: Constant.dateWrongJSON5)

        switch TimeZone.current.identifier {
        case "Europe/Moscow":
            XCTAssertEqual(decoded.firstDate, Constant.dateJSONFirstDate)
            XCTAssertEqual(decoded.secondDate, Constant.dateJSONSecondDate)
        default:
            break
        }
    }

    func test_decodeDate_fail() throws {
        switch TimeZone.current.identifier {
        case "Europe/Moscow":
            XCTAssertThrowsError(try Self.decode(type: DecodeDate.self, from: Constant.dateWrongJSON3))
            XCTAssertThrowsError(try Self.decode(type: DecodeDate.self, from: Constant.dateWrongJSON4))
        default:
            break
        }
    }

}

// MARK: - Helpers

private extension KeyedDecodingContainerExtTests {

    static func decode<Base: Decodable>(type: Base.Type, from json: String) throws -> Base {
        guard let data = json.data(using: .utf8) else {
            throw TestError.nilData
        }
        return try JSONDecoder().decode(Base.self, from: data)
    }

}

// MARK: - Constants

private extension KeyedDecodingContainerExtTests {

    // swiftlint:disable line_length
    enum Constant {

        static let collectionJSON1 = #" { "array": [1,2,3,4,5,6,7,8,9] } "#
        static let collectionJSON2 = #" { "array": [1,2,3,"some",5,6,7,[1,2,3],9] } "#
        static let collectionWrongJSON1 = #" { "array": "some" } "#
        static let collectionWrongJSON2 = #" { "notThatArray": [1,2,3,"some",5,6,7,[1,2,3],9] } "#

        static let collectionJSON1Count = 9
        static let collectionJSON2Count = 7

        static let stringJSON1 = #" { "firstString": "First String Value", "secondString": "Second String Value", "thirdString": "Third String Value" } "#
        static let stringWrongJSON1 = #" { "firstString": "First String Value", "secondString": "Second String Value" } "#
        static let stringWrongJSON2 = #" { "firstString": "First String Value", "secondString": "", "thirdString": "Third String Value" } "#
        static let stringWrongJSON3 = #" { "firstString": "First String Value", "thirdString": "" } "#
        static let stringWrongJSON4 = #" { "firstString": "First String Value", "thirdString": 6 } "#

        static let stringJSONFirstString = "First String Value"
        static let stringJSONSecondString = "Second String Value"
        static let stringJSONThirdString = "Third String Value"

        static let dateJSON1 = #" { "firstDate": "2020-06-12T18:15:56Z", "secondDate": "2002-12-12T09:35:56Z" } "#

        static let dateWrongJSON1 = #" { "firstDate": "2020-06-12T18:15:56Z" } "#
        static let dateWrongJSON2 = #" { "firstDate": "2020-06-12T18:15:56Z", "secondDate": "2002-12-12 09:35:56 +0000" } "#
        static let dateWrongJSON3 = #" { "firstDate": "2002-12-12 09:35:56 +0000" } "#
        static let dateWrongJSON4 = #" { "firstDate": "2020-06-12T18:15:56Z", "secondDate": "2021-03-28T13:00:22" } "#
        static let dateWrongJSON5 = #" { "firstDate": "2020-06-12T21:15:56", "secondDate": "2002-12-12T12:35:56" } "#

        static let dateJSONFirstDate = Date(timeIntervalSinceReferenceDate: 613678556)
        static let dateJSONSecondDate = Date(timeIntervalSinceReferenceDate: 61378556)

    }
    // swiftlint:enable line_length

}

// MARK: - Test Error

private extension KeyedDecodingContainerExtTests {

    enum TestError: Error {

        case nilData

    }

}

// swiftlint:disable nesting
// MARK: - Mock DecodeCollectionSafely

private extension KeyedDecodingContainerExtTests {

    struct DecodeCollectionSafely: Decodable {

        enum CodingKeys: String, CodingKey {
            case array
        }

        let array: [Int]

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            array = try container.decodeCollectionSafely(forKey: .array)
        }

    }

}

// MARK: - Mock DecodeCollectionSafelyIfPresent

private extension KeyedDecodingContainerExtTests {

    struct DecodeCollectionSafelyIfPresent: Decodable {

        enum CodingKeys: String, CodingKey {
            case array
        }

        let array: [Int]

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            array = try container.decodeCollectionSafelyIfPresent(forKey: .array)
        }

    }

}

// MARK: - Mock DecodeNotEmptyString

private extension KeyedDecodingContainerExtTests {

    struct DecodeNotEmptyString: Decodable {

        enum CodingKeys: String, CodingKey {
            case firstString
            case secondString
            case thirdString
        }

        let firstString: String
        let secondString: String
        let thirdString: String

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            firstString = try container.decodeNotEmptyString(forKey: .firstString)
            secondString = try container.decodeNotEmptyString(forKey: .secondString)
            thirdString = try container.decodeNotEmptyString(forKey: .thirdString)
        }

    }

}

// MARK: - Mock DecodeNotEmptyStringIfPresent

private extension KeyedDecodingContainerExtTests {

    struct DecodeNotEmptyStringIfPresent: Decodable {

        enum CodingKeys: String, CodingKey {
            case firstString
            case secondString
            case thirdString
        }

        let firstString: String?
        let secondString: String?
        let thirdString: String?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            firstString = try container.decodeNotEmptyStringIfPresent(forKey: .firstString)
            secondString = try container.decodeNotEmptyStringIfPresent(forKey: .secondString)
            thirdString = try container.decodeNotEmptyStringIfPresent(forKey: .thirdString)
        }

    }

}

// MARK: - Mock DecodeISO8601Date

private extension KeyedDecodingContainerExtTests {

    struct DecodeISO8601Date: Decodable {

        enum CodingKeys: String, CodingKey {
            case firstDate
            case secondDate
        }

        let firstDate: Date
        let secondDate: Date

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            firstDate = try container.decodeISO8601Date(forKey: .firstDate)
            secondDate = try container.decodeISO8601Date(forKey: .secondDate)
        }

    }

}

// MARK: - Mock DecodeISO8601DateIfPresent

private extension KeyedDecodingContainerExtTests {

    struct DecodeISO8601DateIfPresent: Decodable {

        enum CodingKeys: String, CodingKey {
            case firstDate
            case secondDate
        }

        let firstDate: Date?
        let secondDate: Date?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            firstDate = try container.decodeISO8601DateIfPresent(forKey: .firstDate)
            secondDate = try container.decodeISO8601DateIfPresent(forKey: .secondDate)
        }

    }

}

// MARK: - Mock DecodeDate

private extension KeyedDecodingContainerExtTests {

    struct DecodeDate: Decodable {

        enum CodingKeys: String, CodingKey {
            case firstDate
            case secondDate
        }

        let firstDate: Date?
        let secondDate: Date?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            firstDate = try container.decodeDate(forKey: .firstDate)
            secondDate = try container.decodeDate(forKey: .secondDate)
        }

    }

}
// swiftlint:enable nesting
