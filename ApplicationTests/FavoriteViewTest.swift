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

func compare(_ left: UIImage, _ right: UIImage) -> ImageComparisonResult {
    let image1 = CIImage(image: left)!
    let image2 = CIImage(image: right)!
    let diffOperation = diff(image1, image2)
    return ImageComparisonResult(difference: diffOperation.outputImage!)
}

struct ImageComparisonResult {
    let difference: CIImage
    
    func maxColorDifference() -> Float {
        maxColorDiff(histogram: histogram(ciImage: difference))
    }
}

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
        
        XCTContext.runActivity(named: "compare images") {
            $0.add(.init(data: png, uniformTypeIdentifier: UTType.png.identifier))
            let diff = compare(image, UIImage(data: existing)!)
            XCTAssertEqual(0, diff.maxColorDifference(), accuracy: 0.02)
        }
    }
}
