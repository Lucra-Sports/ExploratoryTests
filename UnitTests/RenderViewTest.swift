//
//  RenderViewTest.swift
//  ExperimentsTests
//
//  Created by Paul Zabelin on 5/11/22.
//

import XCTest
import SwiftUI

class RenderViewTest: XCTestCase {
    let sampleView: UIView = {
        let frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 20))
        let view = UIView(frame: frame)        
        view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    func testRenderLayer() throws {
        let image = try XCTUnwrap(sampleView.renderLayerAsBitmap())
        XCTAssertNotNil(image)
        XCTAssertEqual(image.size, .init(width: 40, height: 20))
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl().appendingPathComponent("sampleView.png")
        )
        XCTAssertEqual(existing, png)
        try png.write(to: URL(fileURLWithPath: "/tmp/sampleView.png"))
    }
    
    func testSwiftUIRendersBlank() throws {
        let controller = UIHostingController(rootView: SampleView())
        let view = controller.view!
        view.frame = .init(origin: .zero, size: view.intrinsicContentSize)
        let image = try XCTUnwrap(view.renderLayerAsBitmap())
        XCTAssertNotNil(image)
        XCTAssertEqual(image.size, .init(width: 30, height: 20))
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl().appendingPathComponent("sampleSwiftUIView-blank.png")
        )
        XCTAssertEqual(existing, png)
        try png.write(to: URL(fileURLWithPath: "/tmp/sampleSwiftUIView.png"))
    }
    
}
