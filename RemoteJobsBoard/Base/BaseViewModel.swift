import Combine
import CombineExtensions
import Foundation
import XCoordinator

class BaseViewModel<RouteModel: Route> {

	// MARK: - Typealiases

	typealias RouteModel = RouteModel
	typealias Router = WeakRouter<RouteModel>

	// MARK: - Properties

	let logger: LoggerServiceType
	let router: Router

	let cancellable = CombineCancellable()

	lazy var errorHandler: ErrorHandler = { [weak self] in
		self?.log(error: $0)
	}

	// MARK: - Initialization

	init(router: Router, services: ServicesContainer) {
		self.router = router
		self.logger = services.logger
	}

	// MARK: - Deinitialization

	deinit {
		logger.log(deinitOf: self)
	}

	// MARK: - Public

	func bindRoutes() {}

	/// If you override this method, `super` must be called.
	func bind() {
		bindRoutes()
	}

	func trigger(_ route: RouteModel) {
		DispatchQueue.main.async { [weak self] in
			self?.router.trigger(route)
		}
	}

	func log(error: Error) {
		logger.log(error: error)
	}

}
