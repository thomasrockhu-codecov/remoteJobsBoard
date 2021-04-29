import UIKit

final class JobDetailsDataSource: BaseTableViewDataSource<JobDetailsSections> {

    // MARK: - Properties

    private let viewModel: JobDetailsViewModelType

    // MARK: - Initialization

    init(viewModel: JobDetailsViewModelType, tableView: UITableView, services: ServicesContainer) {
        self.viewModel = viewModel

        super.init(tableView: tableView, services: services) {
            switch $2 {
            case .jobTitle(let jobTitle):
                let cell: JobDetailsTitleCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: jobTitle)
                return cell
            case let .locationSalary(location: location, salary: salary):
                let cell: JobDetailsLocationSalaryCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(location: location, salary: salary)
                return cell
            case .description(let description):
                let cell: JobDetailsDescriptionCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: description)
                cell.onWebViewContentHeightChange = { [weak tableView] in
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
                return cell
            case .companyName(let companyName):
                let cell: JobDetailsCompanyNameCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: companyName)
                return cell
            case .category(let categoryName):
                let cell: JobDetailsCategoryCell = try $0.dequeueReusableCell(for: $1)
                cell.configure(with: categoryName)
                return cell
            }
        }
    }

    // MARK: - Base Class

    override func configureTableView(_ tableView: UITableView) {
        super.configureTableView(tableView)

        tableView.register(cellClass: JobDetailsTitleCell.self)
        tableView.register(cellClass: JobDetailsLocationSalaryCell.self)
        tableView.register(cellClass: JobDetailsDescriptionCell.self)
        tableView.register(cellClass: JobDetailsCompanyNameCell.self)
        tableView.register(cellClass: JobDetailsCategoryCell.self)

        tableView.separatorStyle = .none
        tableView.delegate = self
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

// MARK: - UITableViewDelegate

extension JobDetailsDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? JobDetailsDescriptionCell)?.didEndDisplaying()
    }

}
