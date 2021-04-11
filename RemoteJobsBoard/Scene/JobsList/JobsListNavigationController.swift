import UIKit

final class JobsListNavigationController: UINavigationController {

    // MARK: - Base Class

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.prefersLargeTitles = true
        navigationBar.barTintColor = Color.JobsList.background
    }

}
