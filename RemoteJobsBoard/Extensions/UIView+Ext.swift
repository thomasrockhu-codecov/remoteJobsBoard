import UIKit

// MARK: - Constraints Makers

extension UIView {

    typealias ConstraintsMaker = (_ view: UIView, _ superView: UIView) -> [NSLayoutConstraint]
    typealias ArrangedSubviewConstraintsMaker = (_ view: UIView, _ stackView: UIStackView) -> [NSLayoutConstraint]

    // swiftlint:disable line_length
    /// Adds view as subview to given view, sets `translatesAutoresizingMaskIntoConstraints` to `false`
    /// and activates constraints returned in `constraintsMaker` closure.
    /// - Parameters:
    ///   - view: View we're working with.
    ///   - constraintsMaker: First argument is a view we're working with. Second arguments is a view's superview. Returns an array of constraints that will be activated in superview.
    // swiftlint:enable line_length
    func add(to view: UIView, constraintsMaker: ConstraintsMaker) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(constraintsMaker(self, view))
    }

    // swiftlint:disable line_length
    /// Adds view as an arranged subview to given stack view, sets `translatesAutoresizingMaskIntoConstraints` to `false` and activates constraints returned in `constraintsMaker` closure.
    /// - Parameters:
    ///   - stackView: UIStackView we're adding the view to.
    ///   - constraintsMaker: First argument is a view we're working with. Second arguments is a view's superview. Returns an array of constraints that will be activated in superview.
    // swiftlint:enable line_length
    func addAsArrangedSubview(to stackView: UIStackView, constraintsMaker: ArrangedSubviewConstraintsMaker? = nil) {
        stackView.addArrangedSubview(self)
        guard let constraintsMaker = constraintsMaker else { return }
        translatesAutoresizingMaskIntoConstraints = false
        stackView.addConstraints(constraintsMaker(self, stackView))
    }

}

// MARK: - Margin Anchors

extension UIView {

    /// `layoutMarginsGuide`'s leading anchor.
    var leadingMarginAnchor: NSLayoutXAxisAnchor {
        layoutMarginsGuide.leadingAnchor
    }

    /// `layoutMarginsGuide`'s trailing anchor.
    var trailingMarginAnchor: NSLayoutXAxisAnchor {
        layoutMarginsGuide.trailingAnchor
    }

    /// `layoutMarginsGuide`'s bottom anchor.
    var bottomMarginAnchor: NSLayoutYAxisAnchor {
        layoutMarginsGuide.bottomAnchor
    }

    /// `layoutMarginsGuide`'s top anchor.
    var topMarginAnchor: NSLayoutYAxisAnchor {
        layoutMarginsGuide.topAnchor
    }

    /// `layoutMarginsGuide`'s center `y` anchor.
    var centerYMarginAnchor: NSLayoutYAxisAnchor {
        layoutMarginsGuide.centerYAnchor
    }

    /// `layoutMarginsGuide`'s center `x` anchor.
    var centerXMarginAnchor: NSLayoutXAxisAnchor {
        layoutMarginsGuide.centerXAnchor
    }

}

// MARK: - Safe Area Anchors

extension UIView {

    /// `safeAreaLayoutGuide`s leading anchor.
    var leadingSafeAnchor: NSLayoutXAxisAnchor {
        safeAreaLayoutGuide.leadingAnchor
    }

    /// `safeAreaLayoutGuide`s trailing anchor.
    var trailingSafeAnchor: NSLayoutXAxisAnchor {
        safeAreaLayoutGuide.trailingAnchor
    }

    /// `safeAreaLayoutGuide`s bottom anchor.
    var bottomSafeAnchor: NSLayoutYAxisAnchor {
        safeAreaLayoutGuide.bottomAnchor
    }

    /// `safeAreaLayoutGuide`s top anchor.
    var topSafeAnchor: NSLayoutYAxisAnchor {
        safeAreaLayoutGuide.topAnchor
    }

    /// `safeAreaLayoutGuide`s center `y` anchor.
    var centerYSafeAnchor: NSLayoutYAxisAnchor {
        safeAreaLayoutGuide.centerYAnchor
    }

    /// `safeAreaLayoutGuide`s center `x` anchor.
    var centerXSafeAnchor: NSLayoutXAxisAnchor {
        safeAreaLayoutGuide.centerXAnchor
    }

}
