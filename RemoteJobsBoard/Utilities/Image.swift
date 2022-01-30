// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
import UIKit

// swiftlint:disable let_var_whitespace superfluous_disable_command
enum Image {

  enum JobCategory {
    static var business: UIImage { Asset(name: "JobCategory/business").image }
    static var customerService: UIImage { Asset(name: "JobCategory/customerService").image }
    static var data: UIImage { Asset(name: "JobCategory/data").image }
    static var design: UIImage { Asset(name: "JobCategory/design").image }
    static var financeAndLegal: UIImage { Asset(name: "JobCategory/financeAndLegal").image }
    static var humanResources: UIImage { Asset(name: "JobCategory/humanResources").image }
    static var marketing: UIImage { Asset(name: "JobCategory/marketing").image }
    static var other: UIImage { Asset(name: "JobCategory/other").image }
    static var product: UIImage { Asset(name: "JobCategory/product").image }
    static var softwareDevelopment: UIImage { Asset(name: "JobCategory/softwareDevelopment").image }
    static var writing: UIImage { Asset(name: "JobCategory/writing").image }
  }

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
