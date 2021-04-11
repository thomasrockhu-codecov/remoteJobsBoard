import Foundation

// swiftlint:disable line_length superfluous_disable_command
enum LocalizedString {}

// MARK: - Navigation Titles

extension LocalizedString {

    enum NavigationTitle {

        /// Localized string with a key equal to `NavigationTitle.jobsList`
        /// and value equal to `Remote Jobs Board`.
        static var jobsList: String {
            NSLocalizedString("NavigationTitle.jobsList",
                              value: "Remote Jobs Board",
                              comment: "Title of jobs list view.")
        }

    }

}
// swiftlint:enable line_length superfluous_disable_command
