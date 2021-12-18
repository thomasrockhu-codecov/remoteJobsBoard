import Combine
import Foundation

protocol APIServiceType: AnyObject {
	
	typealias JobsPublisher = AnyPublisher<[Job], Error>
	
	func getJobs() -> JobsPublisher
	
}
