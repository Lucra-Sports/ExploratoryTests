//
//  ExperimentsTests.swift
//  ExperimentsTests
//
//  Created by Paul Zabelin on 4/14/22.
//

import XCTest
import SwiftUI
@testable import Experiments
import UniformTypeIdentifiers

class RenderInWindowTest: XCTestCase {
    override func setUp() {
        super.setUp()
        let appHasWindow = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "keyWindow != nil"),
            object: UIApplication.shared
        )
        wait(for: [appHasWindow], timeout: 10)
    }
    
    func testRenderPreview() throws {
        let size = CGSize(width: 556, height: 157)
            .applying(scaleDeviceToPoints)
        let image = try onScreenView(ContentView_Previews.previews) { view -> UIImage in
            XCTAssertEqual(view.intrinsicContentSize, size)
            return view.renderHierarchyOnScreen()
        }
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl().appendingPathComponent("samplePreview.png")
        )
        XCTContext.runActivity(named: "compare images") {
            $0.add(.init(data: png, uniformTypeIdentifier: UTType.png.identifier))
            let diff = compare(image, UIImage(data: existing)!)
            XCTAssertEqual(0, diff.maxColorDifference(), accuracy: 0.02)
        }
    }

    func testRenderInWindow() throws {
        let image = try onScreenView(SampleView()) { view -> UIImage in
            XCTAssertEqual(view.intrinsicContentSize, .init(width: 30, height: 20))
            return view.renderHierarchyOnScreen()
        }
        
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl().appendingPathComponent("sampleSwiftUIView-in-window.png")
        )
        XCTContext.runActivity(named: "compare images") {
            $0.add(.init(data: png, uniformTypeIdentifier: UTType.png.identifier))
            let diff = compare(image, UIImage(data: existing)!)
            XCTAssertEqual(0, diff.maxColorDifference(), accuracy: 0.02)
        }
    }
}
