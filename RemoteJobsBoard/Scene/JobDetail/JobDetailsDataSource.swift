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

        tableView.separatorStyle = .none
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
