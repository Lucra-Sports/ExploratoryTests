//
//  ExperimentsUITests.swift
//  ExperimentsUITests
//
//  Created by Paul Zabelin on 4/14/22.
//

import XCTest

class ExperimentsUITests: XCTestCase {
    let app = XCUIApplication()
    let timeout: TimeInterval = 60

    override func setUp() async throws {
        continueAfterFailure = false
    }
    
    func test1DateFormatterRace() throws {
        reproduceCrash("Race DateFormatter")
    }

    func test2TaskRace() throws {
        reproduceCrash("Race Task Cancellation")
    }
    
    func test3AnyCancellableSetRace() throws {
        reproduceCrash("Race AnyCancellable Set")
    }
    
    func reproduceCrash(_ button: String) {
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: timeout))
        verifyAppCrash {
            app.buttons[button].tap()
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
