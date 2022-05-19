//
//  ExperimentsTests.swift
//  ExperimentsTests
//
//  Created by Paul Zabelin on 4/14/22.
//

import XCTest
import SwiftUI

class RenderInWindowTest: XCTestCase {
    let folderUrl = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
    
    override func setUp() {
        super.setUp()
        let appHasWindow = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "keyWindow != nil"),
            object: UIApplication.shared
        )
        wait(for: [appHasWindow], timeout: 10)
    }

    func testRenderInWindow() throws {
        let window = try XCTUnwrap(UIApplication.shared.value(forKey: "keyWindow") as? UIWindow)
        let controller = UIHostingController(rootView: SampleView())
        window.rootViewController = controller
        let view = try XCTUnwrap(controller.view)
        XCTAssertEqual(view.intrinsicContentSize, .init(width: 30, height: 101))
        view.bounds = .init(origin: .zero, size: .init(width: 30, height: 20))
        let image = controller.view.renderHierarchyOnScreen()
        
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl.appendingPathComponent("sampleSwiftUIView-in-window.png")
        )
        XCTAssertEqual(existing, png)
        try png.write(to: URL(fileURLWithPath: "/tmp/sampleSwiftUIView-in-window.png"))

    }
}
