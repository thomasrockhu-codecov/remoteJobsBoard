import UIKit

class BaseJobDetailsCell: BaseTableViewCell {

    // MARK: - Base Class

    override func configureSubviews() {
        super.configureSubviews()

        selectionStyle = .none
        backgroundColor = Color.JobsList.background
    }

}
