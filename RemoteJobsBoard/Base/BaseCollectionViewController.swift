import CombineExtensions
import UIKit

/// Base class for all collection view controllers.
class BaseCollectionViewController: UICollectionViewController {

    // MARK: - Properties

    let services: ServicesContainer

    let subscriptions = CombineCancellable()

    var navigationItemTitle: String? {
        nil
    }

    var backgroundColor: UIColor? {
        .systemBackground
    }

    // MARK: - Initialization

    init(services: ServicesContainer) {
        self.services = services

        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Deinitialization

    deinit {
        services.logger.log(deinitOf: self)
    }

    // MARK: - Base Class

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = backgroundColor
        navigationItem.title = navigationItemTitle

        configureSubviews()
        bind()
    }

    // MARK: - Public {

    func configureSubviews() {}
    func bind() {}

}
