import Foundation

extension Collection {

	var orNil: Self? {
		isEmpty ? nil : self
	}

	/// Returns the element at the specified index if it is within bounds, otherwise nil.
	subscript(safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}

}
