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
        let size = CGSize(width: 158, height: 148)
            .applying(scaleDeviceToPoints)
        
        let image = try onScreenView(FavoriteView_Previews.previews) { view -> UIImage in
            XCTAssertEqual(view.intrinsicContentSize, size)
            return view.renderHierarchyOnScreen()
        }
        
        let png = try XCTUnwrap(image.pngData())
        let existing = try Data(
            contentsOf: folderUrl().appendingPathComponent("FavoriteViewPreview.png")
        )
        
        let image1 = CIImage(image: image)!
        let image2 = CIImage(image: UIImage(data: existing)!)!
        let diffOperation = diff(image1, image2)
        let diffOutput = diffOperation.outputImage!
        let diff = maxColorDiff(histogram: histogram(ciImage: diffOutput))

        XCTContext.runActivity(named: "compare images") {
            $0.add(.init(data: png, uniformTypeIdentifier: UTType.png.identifier))
            XCTAssertEqual(0, diff, accuracy: 0.02)
        }
    }
}
