import Atributika
import Combine
import CombineExt
import UIKit
import WebKit

final class JobDetailsDescriptionCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    private typealias ColorAsset = RemoteJobsBoard.Color.DescriptionCell

    // MARK: - Properties

    private(set) lazy var selectedLink = PassthroughRelay<URL>()
    private(set) lazy var selectedPhoneNumber = PassthroughRelay<String>()

    private lazy var descriptionLabel = AttributedLabel()

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Description Label.
        descriptionLabel.numberOfLines = 0

        descriptionLabel.onClick = { [weak self] _, detection in
            switch detection.type {
            case .link(let link):
                self?.selectedLink.accept(link)
            case .phoneNumber(let phoneNumber):
                self?.selectedPhoneNumber.accept(phoneNumber)
            case .tag(let tag) where tag.name == "a":
                guard
                    let href = tag.attributes["href"],
                    let url = URL(string: href)
                else {
                    break
                }
                self?.selectedLink.accept(url)
            default:
                break
            }
        }

        descriptionLabel.add(to: contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor)]
        }
    }

}

// MARK: - Public Methods

extension JobDetailsDescriptionCell {

    func configure(with description: String) {
        descriptionLabel.attributedText = description
            .style(tags: Constant.tagStyles)
            .stylePhoneNumbers(Constant.linkStyle)
            .styleAll(Constant.bodyStyle)
    }

    func bind(to viewModel: JobDetailsViewModelType) {
        selectedLink
            .subscribe(viewModel.inputs.selectedLink)
            .store(in: &reusablesubscriptionsStore)
        selectedPhoneNumber
            .subscribe(viewModel.inputs.selectedPhoneNumber)
            .store(in: &reusablesubscriptionsStore)
    }

}

// MARK: - Constants

private extension JobDetailsDescriptionCell {

    enum Constant {

        static var tagStyles: [Style] {
            [strongStyle, boldStyle, italicStyle, linkStyle]
        }

        static let bodyStyle = Style.font(font)
        static let strongStyle = Style("strong").font(boldFont)
        static let boldStyle = Style("b").font(boldFont)
        static let italicStyle = Style("i").font(italicFont)

        static let linkStyle = Style("a")
            .font(font)
            .foregroundColor(ColorAsset.descriptionLinkColor, .normal)
            .foregroundColor(.brown, .highlighted)

        private static let font = UIFont.preferredFont(forTextStyle: .body)
        private static let boldFont = UIFont.boldSystemFont(ofSize: font.pointSize)
        private static let italicFont = UIFont.italicSystemFont(ofSize: font.pointSize)

    }

}
