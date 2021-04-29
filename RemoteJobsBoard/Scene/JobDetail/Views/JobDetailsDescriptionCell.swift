import UIKit
import WebKit

final class JobDetailsDescriptionCell: BaseJobDetailsCell {

    // MARK: - Typealiases

    typealias WebViewContentHeightChangeHandler = () -> Void

    // MARK: - Properties

    var onWebViewContentHeightChange: WebViewContentHeightChangeHandler?

    private var descriptionWebViewHeightConstraint: NSLayoutConstraint?

    private lazy var descriptionWebView = makeDescriptionWebView()
    private lazy var descriptionWebViewContentController = WKUserContentController()

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        // Description Web View.
        descriptionWebView.scrollView.isScrollEnabled = false
        descriptionWebView.isOpaque = false

        let descriptionWebViewHeightConstraint = descriptionWebView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constant.heightAnchor)
        self.descriptionWebViewHeightConstraint = descriptionWebViewHeightConstraint
        descriptionWebView.add(to: contentView) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingMarginAnchor),
             $0.topAnchor.constraint(equalTo: $1.topMarginAnchor),
             $1.trailingMarginAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomMarginAnchor.constraint(equalTo: $0.bottomAnchor),
             descriptionWebViewHeightConstraint]
        }
    }

}

// MARK: - WKScriptMessageHandler

extension JobDetailsDescriptionCell: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let responseDict = message.body as? [String: Any],
            responseDict["justLoaded"] != nil,
            let responseHeight = responseDict["height"] as? Float
        else {
            return
        }

        let height = CGFloat(responseHeight)

        guard self.descriptionWebViewHeightConstraint?.constant != height else { return }

        let scale = UIScreen.main.scale - 0.25
        self.descriptionWebViewHeightConstraint?.constant = height / scale

        self.onWebViewContentHeightChange?()
    }

}

// MARK: - Public Methods

extension JobDetailsDescriptionCell {

    func configure(with description: String) {
        descriptionWebViewContentController.add(self, name: Constant.sizeNotificationName)

        let description = "<font size=30>" + description + "</font>"
        DispatchQueue.main.async { [weak descriptionWebView] in
            descriptionWebView?.loadHTMLString(description, baseURL: nil)
        }
    }

    func didEndDisplaying() {
        descriptionWebViewContentController.removeScriptMessageHandler(forName: Constant.sizeNotificationName)
    }

}

// MARK: - Private Methods

private extension JobDetailsDescriptionCell {

    func makeDescriptionWebView() -> WKWebView {
        let script = WKUserScript(source: Constant.scriptSource1, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let script2 = WKUserScript(source: Constant.scriptSource2, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        descriptionWebViewContentController.addUserScript(script)
        descriptionWebViewContentController.addUserScript(script2)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = descriptionWebViewContentController

        return WKWebView(frame: CGRect.zero, configuration: configuration)
    }

}

// MARK: - Constants

private extension JobDetailsDescriptionCell {

    enum Constant {

        static let heightAnchor: CGFloat = 500
        static let sizeNotificationName = "sizeNotification"

        // swiftlint:disable line_length
        static let scriptSource1 = "window.onload=function () {window.webkit.messageHandlers.sizeNotification.postMessage({justLoaded:true,height: document.body.scrollHeight});};"
        static let scriptSource2 = "document.body.addEventListener( 'resize', incrementCounter); function incrementCounter() {window.webkit.messageHandlers.sizeNotification.postMessage({height: document.body.scrollHeight});};"
        // swiftlint:enable line_length

    }

}
