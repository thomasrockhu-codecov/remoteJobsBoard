import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?

    private lazy var services = Self.makeServicesContainer()
    private lazy var coordinator = JobsListCoordinator(services: services)

    // MARK: - UIWindowSceneDelegate

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        let onError: ErrorHandler = { [weak services] in
            services?.logger.log(error: $0)
        }

        Image.onError = onError
        Color.onError = onError

        guard let window = makeWindow(with: scene) else { return }
        self.window = window
        coordinator.setRoot(for: window)
    }

}

// MARK: - Private Methods

private extension SceneDelegate {

    static func makeServicesContainer() -> ServicesContainer {
        let logger = LoggerService()

        return ServicesContainer(logger: logger)
    }

    func makeWindow(with scene: UIScene) -> UIWindow? {
        guard let scene = scene as? UIWindowScene else {
            services.logger.log(error: "Unexpected scene in SceneDelegate")
            return nil
        }

        return UIWindow(windowScene: scene)
    }

}
