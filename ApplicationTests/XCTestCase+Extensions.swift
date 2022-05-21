//
//  XCTestCase+Extensions.swift
//  ApplicationTests
//
//  Created by Paul Zabelin on 5/21/22.
//

import XCTest

extension XCTestCase {
    var folderUrl: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
    }
    var scalePointsToDevice: CGAffineTransform {
        CGAffineTransform(scaleX: UIScreen.main.scale, y: UIScreen.main.scale)
    }
    var scaleDeviceToPoints: CGAffineTransform {
        scalePointsToDevice.inverted()
    }
}

public func XCTAssertEqual(_ expression1: @autoclosure () throws -> CGSize, _ expression2: @autoclosure () throws -> CGSize, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    let left = try! expression1()
    let right = try! expression2()
    let message = message()
    XCTAssertEqual(left.height, right.height, accuracy: 0.1, "height " + message, file: file, line: line)
    XCTAssertEqual(left.width, right.width, accuracy: 0.1, "width " + message, file: file, line: line)
}
