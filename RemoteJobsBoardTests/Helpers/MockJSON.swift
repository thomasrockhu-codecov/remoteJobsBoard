import Foundation

enum MockJSON {

    case full
    case emptyTitle
    case noTitle
    case badTitle
    case emptyURL
    case noURL
    case badURL1
    case badURL2

    var fileName: String {
        switch self {
        case .badTitle:
            return "JobsResponseModel_BadTitle"
        case .badURL1:
            return "JobsResponseModel_BadURL_1"
        case .badURL2:
            return "JobsResponseModel_BadURL_2"
        case .emptyTitle:
            return "JobsResponseModel_EmptyTitle"
        case .emptyURL:
            return "JobsResponseModel_EmptyURL"
        case .full:
            return "JobsResponseModel_Full"
        case .noTitle:
            return "JobsResponseModel_NoTitle"
        case .noURL:
            return "JobsResponseModel_NoURL"
        }
    }

}
