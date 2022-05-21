//
//  FavoriteViewTest.swift
//  ApplicationTests
//
//  Created by Paul Zabelin on 5/21/22.
//
@testable import Experiments
import SwiftUI
import XCTest
import UniformTypeIdentifiers

class FavoriteViewTest: XCTestCase {
    func testRenderPreview() throws {
        let window = try XCTUnwrap(UIApplication.shared.value(forKey: "keyWindow") as? UIWindow)
        let controller = UIHostingController(rootView: AnyView(FavoriteView_Previews.previews))
        window.rootViewController = controller
        let view = try XCTUnwrap(controller.view)
        let size = CGSize(width: 158, height: 391)
            .applying(
                CGAffineTransform(scaleX: 3, y: 3)
                    .inverted()
            )
        
        XCTAssertEqual(view.intrinsicContentSize, size)

        let image = controller.view.renderHierarchyOnScreen()
        
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl.appendingPathComponent("FavoriteViewPreview.png")
        )
        XCTContext.runActivity(named: "compare images") {
            $0.add(.init(data: png, uniformTypeIdentifier: UTType.png.identifier))
            XCTAssertEqual(existing, png)
        }
    }
}