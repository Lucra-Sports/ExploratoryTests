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

    override func setUp() async throws {
        continueAfterFailure = false
    }

    func testDateFormatterRace() throws {
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: timeout))
        verifyAppCrash {
            app.buttons["Race DateFormatter"].tap()
        }
    }
    
    func appDidExit() -> DispatchSourceProcess {
        let processId = pid_t(app.value(forKey: "processID") as! Int32)
        
        let source = DispatchSource.makeProcessSource(
            identifier: processId,
            eventMask: .exit
        )
        source.activate()
        return source
    }
    
    func verifyAppCrash(_ block: ()->Void) {
        let processSource = appDidExit()
        let appCrashed = expectation(description: "app crashed")
        processSource.setEventHandler {
            appCrashed.fulfill()
        }
        block()
        wait(for: [appCrashed], timeout: timeout)
        XCTAssertFalse(processSource.isCancelled)
        XCTAssertEqual(processSource.data, .exit)
        app.terminate()
        XCTAssertTrue(app.wait(for: .notRunning, timeout: timeout))
    }
}
