import UIKit

final class TestingAppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Typealiases

    typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {

        false
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        UISceneConfiguration(name: "Test Configuration",
                             sessionRole: connectingSceneSession.role)
    }

}
