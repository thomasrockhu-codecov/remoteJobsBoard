import UIKit

final class JobDetailsDataSource: BaseCollectionViewDataSource<JobDetailsSections> {

    // MARK: - Properties

    private let viewModel: JobDetailsViewModelType

    // MARK: - Initialization

    init(viewModel: JobDetailsViewModelType, collectionView: UICollectionView, services: ServicesContainer) {
        self.viewModel = viewModel

        super.init(collectionView: collectionView, services: services) {
            switch $2 {
            case .jobTitle(let jobTitle):
                let cell: JobDetailsTitleCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: jobTitle)
                return cell
            case .location(let location):
                let cell: JobDetailsLocationCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(location: location)
                return cell
            case .description(let description):
                let cell: JobDetailsDescriptionCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: description)
                cell.bind(to: viewModel)
                return cell
            case .companyName(let companyName):
                let cell: JobDetailsCompanyNameCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: companyName)
                return cell
            case .category(let categoryName):
                let cell: JobDetailsCategoryCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: categoryName)
                return cell
            case let .terms(salary: salary, jobType: jobType):
                let cell: JobDetailsTermsCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(jobType: jobType, salary: salary)
                return cell
            case .publicationDate(let publicationDate):
                let cell: JobDetailsPublicationDateCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: publicationDate)
                return cell
            }
        }
    }

    // MARK: - Base Class

    override func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] index, environment in
            guard let self = self else { return nil }
            let item = self.layoutItem(for: environment, section: index)
            let group = Self.layoutGroup(with: item)
            return self.layoutSection(with: group, index: index)
        }
    }

    override func configureCollectionView(_ collectionView: UICollectionView) {
        super.configureCollectionView(collectionView)

        collectionView.register(cellClass: JobDetailsTitleCell.self)
        collectionView.register(cellClass: JobDetailsTermsCell.self)
        collectionView.register(cellClass: JobDetailsDescriptionCell.self)
        collectionView.register(cellClass: JobDetailsCompanyNameCell.self)
        collectionView.register(cellClass: JobDetailsCategoryCell.self)
        collectionView.register(cellClass: JobDetailsLocationCell.self)
        collectionView.register(cellClass: JobDetailsPublicationDateCell.self)
    }

    override func bind() {
        super.bind()

        viewModel.outputs.job
            .subscribe(on: mappingQueue)
            .map { JobDetailsSections(job: $0).snapshot }
            .receive(on: snapshotQueue)
            .sink { [weak self] in self?.apply($0, animatingDifferences: false) }
            .store(in: &subscriptionsStore)
    }

}

// MARK: - Private Methods - Layout

private extension JobDetailsDataSource {

    static func layoutGroup(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        return .horizontal(layoutSize: size, subitems: [item])
    }

    func layoutItem(for environment: NSCollectionLayoutEnvironment, section: Int) -> NSCollectionLayoutItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        return NSCollectionLayoutItem(layoutSize: size)
    }

    func layoutSection(with group: NSCollectionLayoutGroup, index: Int) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsetsReference = .layoutMargins
        return section
    }

}
