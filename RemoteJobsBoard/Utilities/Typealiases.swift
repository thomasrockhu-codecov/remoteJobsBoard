import Combine
import Foundation

public typealias SubscriptionsStore = Set<AnyCancellable>
public typealias ErrorHandler = (Error) -> Void
