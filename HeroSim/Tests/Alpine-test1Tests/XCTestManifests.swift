import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Alpine_test1Tests.allTests),
    ]
}
#endif