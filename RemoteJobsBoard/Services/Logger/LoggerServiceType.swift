import Foundation

protocol LoggerServiceType: AnyObject {

    func log(error: String)
    func log(error: Error)
    func log(deinitOf object: Any)
    func log(items: Any...)

}
