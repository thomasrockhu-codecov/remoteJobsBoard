// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
import UIKit

// swiftlint:disable let_var_whitespace superfluous_disable_command type_contents_order
enum Color {

    static var accentColor: UIColor { Asset(name: "AccentColor").color }
    enum JobsList {
        static var background: UIColor { Asset(name: "JobsList/background").color }
        static var navigationBarTintColor: UIColor { Asset(name: "JobsList/navigationBarTintColor").color }
    }
    enum LocationSalaryCell {
        static var textColor: UIColor { Asset(name: "LocationSalaryCell/textColor").color }
    }
    enum RecentJobCell {
        static var background: UIColor { Asset(name: "RecentJobCell/background").color }
        static var companyNameTextColor: UIColor { Asset(name: "RecentJobCell/companyNameTextColor").color }
        static var jobTitleTextColor: UIColor { Asset(name: "RecentJobCell/jobTitleTextColor").color }
        static var publicationDateTextColor: UIColor { Asset(name: "RecentJobCell/publicationDateTextColor").color }
    }

    static var onError: ((Error) -> Void)?

}
// swiftlint:enable let_var_whitespace superfluous_disable_command type_contents_order

// MARK: - Color Asset

private extension Color {

    struct Asset {

        let name: String

        var color: UIColor {
            guard let result = UIColor(named: name) else {
                Color.onError?(InitError.colorInit(name: name))
                return .clear
            }
            return result
        }

    }

}

// MARK: - InitError

extension Color {

    enum InitError: Error {

        case colorInit(name: String)

    }

}
