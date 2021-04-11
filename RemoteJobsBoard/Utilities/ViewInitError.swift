import Foundation

enum ViewInitError: Error {

    case tableViewCell(identifier: String)
    case tableViewHeaderFooterView(identifier: String)
    case collectionViewCell(identifier: String)
    case collectionViewSupplementaryView(identifier: String)
    case viewNibInstantiation(nibName: String)

}
