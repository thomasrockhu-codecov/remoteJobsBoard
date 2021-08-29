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

// MARK: - Job Type

extension LocalizedString {

    enum JobType {

        /// Localized string with a key equal to `JobType.fullTime`
        /// and value equal to `Full-Time`.
        static var fullTime: String {
            NSLocalizedString("JobType.fullTime",
                              value: "Full-Time",
                              comment: "Title for Full-Time job type.")
        }

        /// Localized string with a key equal to `JobType.contract`
        /// and value equal to `Contract`.
        static var contract: String {
            NSLocalizedString("JobType.contract",
                              value: "Contract",
                              comment: "Title for Contract job type.")
        }

    }

}

// MARK: - Job Details

extension LocalizedString {

    enum JobDetails {

        /// Localized string with a key equal to `JobDetails.applyButtonTitle`
        /// and value equal to `Apply`.
        static var applyButtonTitle: String {
            NSLocalizedString("JobDetails.applyButtonTitle",
                              value: "Apply",
                              comment: "Title of 'Apply to job' button.")
        }
        
    }

}
// swiftlint:enable line_length superfluous_disable_command
