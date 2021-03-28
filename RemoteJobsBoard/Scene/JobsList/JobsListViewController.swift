import Combine
import CombineExt
import UIKit
import WebKit

final class JobsListViewController: BaseCollectionViewController {

    // MARK: - Properties

    private let viewModel: JobsListViewModelType

    private lazy var webView = WKWebView()

    // MARK: - Initialization

    init(services: ServicesContainer, viewModel: JobsListViewModelType) {
        self.viewModel = viewModel

        super.init(services: services)
    }

    // MARK: - Base Class

    override func bind() {
        super.bind()

        viewModel.bind()

        viewModel.outputs.jobs
            .map { $0[safe: 1]?.description ?? "" }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.webView.loadHTMLString($0, baseURL: nil) }
            .store(in: &subscriptionsStore)
    }

    override func configureSubviews() {
        super.configureSubviews()

        webView.add(to: view) {
            [$0.leadingAnchor.constraint(equalTo: $1.leadingSafeAnchor),
             $0.topAnchor.constraint(equalTo: $1.topSafeAnchor),
             $1.trailingSafeAnchor.constraint(equalTo: $0.trailingAnchor),
             $1.bottomSafeAnchor.constraint(equalTo: $0.bottomAnchor)]
        }
    }

}
