import UIKit

extension Job {

	enum Category: Hashable {

		case softwareDevelopment
		case product
		case marketing
		case business
		case financeAndLegal
		case data
		case design
		case writing
		case customerService
		case humanResources
		case other(String)

		var rawValue: String {
			switch self {
			case .softwareDevelopment:
				return "Software Development"
			case .product:
				return "Product"
			case .marketing:
				return "Marketing"
			case .business:
				return "Business"
			case .financeAndLegal:
				return "Finance & Legal"
			case .data:
				return "Data"
			case .design:
				return "Design"
			case .writing:
				return "Writing"
			case .customerService:
				return "Customer Service"
			case .humanResources:
				return "Human Resources"
			case .other(let categoryName):
				return categoryName
			}
		}

		init(rawValue: String) {
			switch rawValue.lowercased() {
			case Self.softwareDevelopment.rawValue.lowercased():
				self = .softwareDevelopment
			case Constant.softwareDevelopmentAlternative.lowercased():
				self = .softwareDevelopment
			case Self.product.rawValue.lowercased():
				self = .product
			case Self.marketing.rawValue.lowercased():
				self = .marketing
			case Self.business.rawValue.lowercased():
				self = .business
			case Self.financeAndLegal.rawValue.lowercased():
				self = .financeAndLegal
			case Constant.financeAndLegalAlternative.lowercased():
				self = .financeAndLegal
			case Constant.financeAndLegalAlternative2.lowercased():
				self = .financeAndLegal
			case Self.data.rawValue.lowercased():
				self = .data
			case Self.design.rawValue.lowercased():
				self = .design
			case Self.writing.rawValue.lowercased():
				self = .writing
			case Self.customerService.rawValue.lowercased():
				self = .customerService
			case Constant.customerServiceAlternative.lowercased():
				self = .customerService
			case Self.humanResources.rawValue.lowercased():
				self = .humanResources
			case Constant.humanResourcesAlternative.lowercased():
				self = .humanResources
			default:
				self = .other(rawValue)
			}
		}

	}

}

// MARK: - JobsListCategoryCellModel

extension Job.Category: JobsListCategoryCellModel {

	var categoryCellCategoryName: String { rawValue }

	var categoryCellCategoryIcon: UIImage {
		typealias Image = RemoteJobsBoard.Image.JobCategory

		switch self {
		case .softwareDevelopment:
			return Image.softwareDevelopment
		case .marketing:
			return Image.marketing
		case .other:
			return Image.other
		case .business:
			return Image.business
		case .humanResources:
			return Image.humanResources
		case .customerService:
			return Image.customerService
		case .writing:
			return Image.writing
		case .design:
			return Image.design
		case .financeAndLegal:
			return Image.financeAndLegal
		case .product:
			return Image.product
		case .data:
			return Image.data
		}
	}

}

// MARK: - Comparable

extension Job.Category: Comparable {

	static func < (lhs: Job.Category, rhs: Job.Category) -> Bool {
		switch (lhs, rhs) {
		case (.other(let lhsOther), .other(let rhsOther)):
			return lhsOther.localizedCaseInsensitiveCompare(rhsOther) == .orderedAscending
		case (.other, _):
			return false
		case (_, .other):
			return true
		default:
			return lhs.rawValue.localizedCaseInsensitiveCompare(rhs.rawValue) == .orderedAscending
		}
	}

}

// MARK: - Constants

private extension Job.Category {

	enum Constant {

		static let softwareDevelopmentAlternative = "SoftwareDevelopment"
		static let financeAndLegalAlternative = "Finance / Legal"
		static let financeAndLegalAlternative2 = "Finance and Legal"
		static let customerServiceAlternative = "CustomerService"
		static let humanResourcesAlternative = "HumanResources"

	}

}
