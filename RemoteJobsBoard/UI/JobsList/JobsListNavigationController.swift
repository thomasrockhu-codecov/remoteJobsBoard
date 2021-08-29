import UIKit

final class JobsListNavigationController: UINavigationController {

    // MARK: - Typealiases

    private typealias Color = RemoteJobsBoard.Color.JobsList

    // MARK: - Base Class

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.prefersLargeTitles = true
        navigationBar.barTintColor = Color.background
        navigationBar.tintColor = Color.navigationBarTintColor

        var titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        titleTextAttributes[.foregroundColor] = Color.navigationBarTintColor
        navigationBar.titleTextAttributes = titleTextAttributes
    }

}
