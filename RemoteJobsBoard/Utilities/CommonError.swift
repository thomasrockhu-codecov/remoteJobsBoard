import Foundation

enum CommonError: Error {
	
	case tableViewCellDequeue(identifier: String)
	case tableViewHeaderFooterViewDequeue(identifier: String)
	case collectionViewCellDequeue(identifier: String)
	case collectionViewSupplementaryViewDequeue(identifier: String)
	case viewNibInstantiation(nibName: String)
	case unexpectedItemIdentifier
	
}
