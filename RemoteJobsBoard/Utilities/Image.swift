// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
import UIKit

// swiftlint:disable let_var_whitespace superfluous_disable_command
enum Image {


    static var onError: ((Error) -> Void)?

}
// swiftlint:enable let_var_whitespace superfluous_disable_command

// MARK: - Image Asset

private extension Image {

    struct Asset {

        let name: String

        var image: UIImage {
            guard let result = UIImage(named: name) else {
                Image.onError?(InitError.imageInit(name: name))
                return UIImage()
            }
            return result
        }

    }

}

// MARK: - InitError

extension Image {

    enum InitError: Error {

        case imageInit(name: String)
        case sfSymbolInit(name: String)

    }

}
