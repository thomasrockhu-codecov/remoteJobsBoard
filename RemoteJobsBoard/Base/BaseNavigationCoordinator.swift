import UIKit
import XCoordinator

/// Base class for all navigation coordinators.
class BaseNavigationCoordinator<RouteType: Route>: NavigationCoordinator<RouteType> {

	// MARK: - Properties

	let services: ServicesContainer

	// MARK: - Initialization

	init(services: ServicesContainer,
			 initialRoute: RouteType,
			 rootViewController: UINavigationController) {

		self.services = services

		super.init(rootViewController: rootViewController, initialRoute: initialRoute)
	}
	
	// MARK: - Deinitialization

	deinit {
		services.logger.log(deinitOf: self)
	}

}
