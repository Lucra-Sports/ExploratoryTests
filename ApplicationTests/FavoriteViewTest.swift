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
    func onScreenView<SwiftUIView: View>(_ swiftUIView: SwiftUIView) throws -> UIView {
        let window = try XCTUnwrap(UIApplication.shared.value(forKey: "keyWindow") as? UIWindow)
        let rootViewController = try XCTUnwrap(window.rootViewController)
        let controller = UIHostingController(rootView: swiftUIView)
        let size = controller.view.intrinsicContentSize
        let view = try XCTUnwrap(controller.view)
        rootViewController.addChild(controller)
        rootViewController.view.addSubview(view)
        controller.didMove(toParent: rootViewController)
        let safeOrigin = window.safeAreaLayoutGuide.layoutFrame.origin
        view.frame = .init(origin: safeOrigin, size: size)
        XCTAssertEqual(size, view.intrinsicContentSize)
        return view
    }
    
    func testRenderPreview() throws {
        let view = try onScreenView(FavoriteView_Previews.previews)
        let size = CGSize(width: 158, height: 148)
            .applying(scaleDeviceToPoints)
        
        XCTAssertEqual(view.intrinsicContentSize, size)

        let image = view.renderHierarchyOnScreen()
        
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl().appendingPathComponent("FavoriteViewPreview.png")
        )
        
        let image1 = CIImage(image: image)!
        let image2 = CIImage(image: UIImage(data: existing, scale: 3)!)!
        let diffOperation = diff(image1, image2)
        let diffOutput = diffOperation.outputImage!
        let diff = maxColorDiff(histogram: histogram(ciImage: diffOutput))

        XCTContext.runActivity(named: "compare images") {
            $0.add(.init(data: png, uniformTypeIdentifier: UTType.png.identifier))
            XCTAssertEqual(0, diff, accuracy: 0.02)
        }
    }
}
