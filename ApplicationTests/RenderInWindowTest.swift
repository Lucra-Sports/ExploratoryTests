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
        let window = try XCTUnwrap(UIApplication.shared.value(forKey: "keyWindow") as? UIWindow)
        let controller = UIHostingController(rootView: AnyView(ContentView_Previews.previews))
        window.rootViewController = controller
        let view = try XCTUnwrap(controller.view)
        let size = CGSize(width: 556, height: 400)
            .applying(scaleDeviceToPoints)
        
        XCTAssertEqual(view.intrinsicContentSize, size)

        let image = controller.view.renderHierarchyOnScreen()
        
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl().appendingPathComponent("samplePreview.png")
        )
        XCTContext.runActivity(named: "compare images") {
            $0.add(.init(image: image))
            XCTAssertEqual(existing, png)
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
            XCTAssertEqual(existing, png)
        }
    }
}
