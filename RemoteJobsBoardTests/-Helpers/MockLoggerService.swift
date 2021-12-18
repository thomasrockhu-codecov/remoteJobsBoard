import Foundation
@testable import RemoteJobsBoard

final class MockLoggerService: LoggerServiceType {
	
	// MARK: - Properties
	
	var loggedDeinitedObject: String?
	var loggedItems: [Any]?
	var loggedError: String?
	
	// MARK: - LoggerServiceType
	
	func log(error: String) {
		loggedError = error
	}
	
	func log(error: Error) {
		loggedError = error.localizedDescription
	}
	
	func log(deinitOf object: Any) {
		loggedDeinitedObject = String(describing: object)
	}
	
	func log(items: Any...) {
		loggedItems = items
	}
	
}
