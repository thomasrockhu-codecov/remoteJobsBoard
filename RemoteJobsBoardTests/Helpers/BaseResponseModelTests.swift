import XCTest
@testable import RemoteJobsBoard

class BaseResponseModelTests<Response: Decodable>: XCTestCase {

    func response(fromMockJSON name: String) throws -> Response {
        let jsonData = try MockJSONLoader.loadJSON(named: name)
        return try JSONDecoder().decode(Response.self, from: jsonData)
    }

}
