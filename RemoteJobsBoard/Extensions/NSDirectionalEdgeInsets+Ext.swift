import UIKit

extension NSDirectionalEdgeInsets {

	init(vertical: CGFloat, horizontal: CGFloat) {
		self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
	}

	init(inset: CGFloat) {
		self.init(top: inset, leading: inset, bottom: inset, trailing: inset)
	}

}
