//
//  ExperimentsUITests.swift
//  ExperimentsUITests
//
//  Created by Paul Zabelin on 4/14/22.
//

import XCTest

class ExperimentsUITests: XCTestCase {
    let app = XCUIApplication()
    let timeout: TimeInterval = 10

    func testDateFormatterRace() throws {
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: timeout))
        try verifyAppCrash {
            app.buttons["Race DateFormatter"].tap()
        }
    }
    
    func expectToCrash() throws -> XCTestExpectation {
        let processId = pid_t(try XCTUnwrap(app.value(forKey: "processID") as? Int32))
        
        let source = DispatchSource.makeProcessSource(
            identifier: processId,
            eventMask: .signal
        )
        source.activate()
        
        let appCrashed = expectation(description: "app crashed")
        source.setEventHandler {
            appCrashed.fulfill()
        }
        return appCrashed
    }
    
    func verifyAppCrash(_ block: ()->Void) throws {
        let appCrashed = try expectToCrash()
        block()
        wait(for: [appCrashed], timeout: timeout)
        XCTAssertTrue(app.wait(for: .notRunning, timeout: timeout))
    }
}
