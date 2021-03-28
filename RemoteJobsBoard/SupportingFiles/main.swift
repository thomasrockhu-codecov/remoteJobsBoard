import UIKit

// swiftlint:disable prefixed_toplevel_constant let_var_whitespace
let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass: AnyClass = isRunningTests
    ? TestingAppDelegate.self
    : AppDelegate.self
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
// swiftlint:enable prefixed_toplevel_constant let_var_whitespace
