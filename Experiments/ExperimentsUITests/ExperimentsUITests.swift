//
//  ExperimentsUITests.swift
//  ExperimentsUITests
//
//  Created by Paul Zabelin on 4/14/22.
//

import XCTest

class ExperimentsUITests: XCTestCase {
    func testDateFormatterRace() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        app.buttons["Race DateFormatter"].tap()
        XCTAssertTrue(app.wait(for: .notRunning, timeout: 30))
    }
}
