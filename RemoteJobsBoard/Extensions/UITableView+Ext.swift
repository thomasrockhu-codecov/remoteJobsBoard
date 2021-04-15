import UIKit

// MARK: - Cells Register & Dequeue

extension UITableView {

    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// - Parameter indexPath: The index path specifying the location of the cell.
    ///   Always specify the index path provided to you by your data source object.
    ///   This method uses the index path to perform additional configuration based on the cell’s position in the table view.
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) throws -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            throw CommonError.tableViewCellDequeue(identifier: identifier)
        }
        return cell
    }

    /// Registers a class for use in creating new table cells.
    /// - Parameter cellClass: The class of a cell that you want to use in the table (must be a UITableViewCell subclass).
    func register<Cell: UITableViewCell>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
        register(Cell.self, forCellReuseIdentifier: identifier)
    }

    /// Registers a nib object containing a cell with the table view.
    /// - Parameters:
    ///   - class: The class of the cell contained in the nib object. The nib and the class must have the same name.
    ///   - bundle: The bundle in which to search for the nib file. If you specify `nil`, this method looks for the nib file in the main bundle.
    func register<Cell: UITableViewCell>(cellNibWithClass class: Cell.Type, bundle: Bundle? = nil) {
        let identifier = String(describing: Cell.self)
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: identifier)
    }

}

// MARK: - Headers/Footers Register & Dequeue

public extension UITableView {

    /// Registers a class for use in creating new table header or footer views.
    /// - Parameter headerFooterClass: The class of a header/footer that you want to use
    ///   in the table (must be a UITableViewHeaderFooterView subclass).
    func register<HeaderFooter: UITableViewHeaderFooterView>(headerFooterClass: HeaderFooter.Type) {
        let identifier = String(describing: HeaderFooter.self)
        register(HeaderFooter.self, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func dequeueReusableHeaderFooterView<HeaderFooter: UITableViewHeaderFooterView>() throws -> HeaderFooter {
        let identifier = String(describing: HeaderFooter.self)
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? HeaderFooter else {
            throw CommonError.tableViewHeaderFooterViewDequeue(identifier: identifier)
        }
        return view
    }

}
