import UIKit
import WebKit

final class JobDetailsDescriptionCell: BaseJobDetailsCell {

    // MARK: - Properties

    private lazy var descriptionWebView = WKWebView()

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Description Web View.
        descriptionWebView.isOpaque = false

        descriptionWebView.add(to: contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor),
             $0.heightAnchor.constraint(equalToConstant: Constant.heightAnchor)]
        }
    }

}

// MARK: - Public Methods

extension JobDetailsDescriptionCell {

    func configure(with description: String) {
        let description = "<font size=30>" + description + "</font>"
        DispatchQueue.main.async { [weak descriptionWebView] in
            descriptionWebView?.loadHTMLString(description, baseURL: nil)
        }
    }

}

// MARK: - Constants

private extension JobDetailsDescriptionCell {

    enum Constant {

        static let heightAnchor: CGFloat = 500

    }

}
