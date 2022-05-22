//
//  SnapshotTests.swift
//  ApplicationTests
//
//  Created by Paul Zabelin on 5/22/22.
//

import XCTest
import ViewSnapshotTesting

class SnapshotTests: XCTestCase {
    func testViews() {
        verifySnapshot(SampleView())
    }
}
