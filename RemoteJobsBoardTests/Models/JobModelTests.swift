@testable import RemoteJobsBoard
import XCTest

final class JobModelTests: XCTestCase {

	// MARK: - Tests

	func test_jobType_init() {
		XCTAssertEqual(Job.JobType(rawValue: "full_time"), .fullTime)
		XCTAssertEqual(Job.JobType(rawValue: "contract"), .contract)
		XCTAssertNil(Job.JobType(rawValue: nil))

		XCTAssertNil(Job.JobType(rawValue: "fullTime"))
		XCTAssertNil(Job.JobType(rawValue: "Contract"))
		XCTAssertNil(Job.JobType(rawValue: "some_wrong_string"))
	}

	func test_category_rawValue() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T.softwareDevelopment.rawValue, C.softwareDevelopment)
		XCTAssertEqual(T.product.rawValue, C.product)
		XCTAssertEqual(T.marketing.rawValue, C.marketing)
		XCTAssertEqual(T.business.rawValue, C.business)
		XCTAssertEqual(T.financeAndLegal.rawValue, C.financeAndLegal)
		XCTAssertEqual(T.data.rawValue, C.data)
		XCTAssertEqual(T.design.rawValue, C.design)
		XCTAssertEqual(T.customerService.rawValue, C.customerService)
		XCTAssertEqual(T.humanResources.rawValue, C.humanResources)
	}

	func test_category_categoryCellCategoryName() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T.softwareDevelopment.categoryCellCategoryName, C.softwareDevelopment)
		XCTAssertEqual(T.product.categoryCellCategoryName, C.product)
		XCTAssertEqual(T.marketing.categoryCellCategoryName, C.marketing)
		XCTAssertEqual(T.business.categoryCellCategoryName, C.business)
		XCTAssertEqual(T.financeAndLegal.categoryCellCategoryName, C.financeAndLegal)
		XCTAssertEqual(T.data.categoryCellCategoryName, C.data)
		XCTAssertEqual(T.design.categoryCellCategoryName, C.design)
		XCTAssertEqual(T.customerService.categoryCellCategoryName, C.customerService)
		XCTAssertEqual(T.humanResources.categoryCellCategoryName, C.humanResources)
	}

	func test_category_comparable() {
		typealias T = Job.Category

		XCTAssertTrue(T.softwareDevelopment > T.business)
		XCTAssertTrue(T.marketing < T.softwareDevelopment)
		XCTAssertTrue(T.softwareDevelopment < T.other("a"))
		XCTAssertTrue(T.softwareDevelopment < T.other("z"))
		XCTAssertTrue(T.other("a") < T.other("z"))
		XCTAssertTrue(T.other("aa") < T.other("az"))
		XCTAssertTrue(T.other("az") > T.other("ab"))
	}

	// MARK: - Tests - Category - Init

	func test_category_init_softwareDevelopment() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.softwareDevelopment), .softwareDevelopment)
		XCTAssertEqual(T(rawValue: C.softwareDevelopmentLower), .softwareDevelopment)
		XCTAssertEqual(T(rawValue: C.softwareDevelopment2), .softwareDevelopment)
		XCTAssertEqual(T(rawValue: C.softwareDevelopment2Lower), .softwareDevelopment)
		XCTAssertEqual(T(rawValue: C.softwareDevelopmentWrong), .other(C.softwareDevelopmentWrong))
		XCTAssertEqual(T(rawValue: C.softwareDevelopmentWrongLower), .other(C.softwareDevelopmentWrongLower))
	}

	func test_category_init_product() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.product), .product)
		XCTAssertEqual(T(rawValue: C.productLower), .product)
		XCTAssertEqual(T(rawValue: C.productWrong), .other(C.productWrong))
		XCTAssertEqual(T(rawValue: C.productWrongLower), .other(C.productWrongLower))
	}

	func test_category_init_marketing() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.marketing), .marketing)
		XCTAssertEqual(T(rawValue: C.marketingLower), .marketing)
		XCTAssertEqual(T(rawValue: C.marketingWrong), .other(C.marketingWrong))
		XCTAssertEqual(T(rawValue: C.marketingWrongLower), .other(C.marketingWrongLower))
	}

	func test_category_init_business() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.business), .business)
		XCTAssertEqual(T(rawValue: C.businessLower), .business)
		XCTAssertEqual(T(rawValue: C.businessWrong), .other(C.businessWrong))
		XCTAssertEqual(T(rawValue: C.businessWrongLower), .other(C.businessWrongLower))
	}

	func test_category_init_financeAndLegal() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.financeAndLegal), .financeAndLegal)
		XCTAssertEqual(T(rawValue: C.financeAndLegalLower), .financeAndLegal)
		XCTAssertEqual(T(rawValue: C.financeAndLegal2), .financeAndLegal)
		XCTAssertEqual(T(rawValue: C.financeAndLegal2Lower), .financeAndLegal)
		XCTAssertEqual(T(rawValue: C.financeAndLegal3), .financeAndLegal)
		XCTAssertEqual(T(rawValue: C.financeAndLegal3Lower), .financeAndLegal)
		XCTAssertEqual(T(rawValue: C.financeAndLegalWrong), .other(C.financeAndLegalWrong))
		XCTAssertEqual(T(rawValue: C.financeAndLegalWrongLower), .other(C.financeAndLegalWrongLower))
	}

	func test_category_init_data() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.data), .data)
		XCTAssertEqual(T(rawValue: C.dataLower), .data)
		XCTAssertEqual(T(rawValue: C.dataWrong), .other(C.dataWrong))
		XCTAssertEqual(T(rawValue: C.dataWrongLower), .other(C.dataWrongLower))
	}

	func test_category_init_design() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.design), .design)
		XCTAssertEqual(T(rawValue: C.designLower), .design)
		XCTAssertEqual(T(rawValue: C.designWrong), .other(C.designWrong))
		XCTAssertEqual(T(rawValue: C.designWrongLower), .other(C.designWrongLower))
	}

	func test_category_init_writing() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.writing), .writing)
		XCTAssertEqual(T(rawValue: C.writingLower), .writing)
		XCTAssertEqual(T(rawValue: C.writingWrong), .other(C.writingWrong))
		XCTAssertEqual(T(rawValue: C.writingWrongLower), .other(C.writingWrongLower))
	}

	func test_category_init_customerService() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.customerService), .customerService)
		XCTAssertEqual(T(rawValue: C.customerServiceLower), .customerService)
		XCTAssertEqual(T(rawValue: C.customerService2), .customerService)
		XCTAssertEqual(T(rawValue: C.customerService2Lower), .customerService)
		XCTAssertEqual(T(rawValue: C.customerServiceWrong), .other(C.customerServiceWrong))
		XCTAssertEqual(T(rawValue: C.customerServiceWrongLower), .other(C.customerServiceWrongLower))
	}

	func test_category_init_humanResources() {
		typealias T = Job.Category
		typealias C = CategoryConstant

		XCTAssertEqual(T(rawValue: C.humanResources), .humanResources)
		XCTAssertEqual(T(rawValue: C.humanResourcesLower), .humanResources)
		XCTAssertEqual(T(rawValue: C.humanResources2), .humanResources)
		XCTAssertEqual(T(rawValue: C.humanResources2Lower), .humanResources)
		XCTAssertEqual(T(rawValue: C.humanResourcesWrong), .other(C.humanResourcesWrong))
		XCTAssertEqual(T(rawValue: C.humanResourcesWrongLower), .other(C.humanResourcesWrongLower))
	}
	
}

// MARK: - Constants

private extension JobModelTests {

	enum CategoryConstant {

		static let softwareDevelopment = "Software Development"
		static let softwareDevelopmentLower = "software development"
		static let softwareDevelopment2 = "Software Development"
		static let softwareDevelopment2Lower = "software development"
		static let softwareDevelopmentWrong = "SoftwareDevelopments"
		static let softwareDevelopmentWrongLower = "softwaredevelopments"

		static let product = "Product"
		static let productLower = "product"
		static let productWrong = "Products"
		static let productWrongLower = "products"

		static let marketing = "Marketing"
		static let marketingLower = "marketing"
		static let marketingWrong = "Marketings"
		static let marketingWrongLower = "marketings"

		static let business = "Business"
		static let businessLower = "business"
		static let businessWrong = "Businesses"
		static let businessWrongLower = "businesses"

		static let financeAndLegal = "Finance & Legal"
		static let financeAndLegalLower = "finance & legal"
		static let financeAndLegal2 = "Finance / Legal"
		static let financeAndLegal2Lower = "finance / legal"
		static let financeAndLegal3 = "Finance and Legal"
		static let financeAndLegal3Lower = "finance and legal"
		static let financeAndLegalWrong = "Finance & Legals"
		static let financeAndLegalWrongLower = "Finance & Legals"

		static let data = "Data"
		static let dataLower = "data"
		static let dataWrong = "Datas"
		static let dataWrongLower = "datas"

		static let design = "Design"
		static let designLower = "design"
		static let designWrong = "Designs"
		static let designWrongLower = "designs"

		static let writing = "Writing"
		static let writingLower = "writing"
		static let writingWrong = "Writings"
		static let writingWrongLower = "writings"

		static let customerService = "Customer Service"
		static let customerServiceLower = "customer service"
		static let customerService2 = "CustomerService"
		static let customerService2Lower = "customerservice"
		static let customerServiceWrong = "CustomerServices"
		static let customerServiceWrongLower = "customerservices"

		static let humanResources = "Human Resources"
		static let humanResourcesLower = "human resources"
		static let humanResources2 = "HumanResources"
		static let humanResources2Lower = "humanresources"
		static let humanResourcesWrong = "HumanResourceses"
		static let humanResourcesWrongLower = "humanresourceses"

	}

}
