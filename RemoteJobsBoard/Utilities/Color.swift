// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
import UIKit

// swiftlint:disable let_var_whitespace superfluous_disable_command
enum Color {

    static var accentColor: UIColor { Asset(name: "AccentColor").color }

    static var onError: ((Error) -> Void)?

}
// swiftlint:enable let_var_whitespace superfluous_disable_command

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
