import XCTest
import SwiftUI

/**
 Compare performance of image snapshot
 using CoreImage vs vImage frameworks
 */
class SnapshotPerformanceTest: XCTestCase {
    var expectedImageUrl: URL!

    override func setUpWithError() throws {
        expectedImageUrl = folderUrl().appendingPathComponent("AvatarView-2.png")
    }
    
    lazy var sampleView: UIView = {
        let frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 20))
        let scale = UIScreen.main.scale
        let data = try! Data(contentsOf: folderUrl().appendingPathComponent("AvatarView-1.png"))
        let image = UIImage(data: data, scale: scale)
        let view = UIImageView(image: image)
        view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        return view
    }()


    func getBitmap() -> UIImage {
        return sampleView.renderLayerAsBitmap()!
    }

    func test_CoreImage_Performance() throws {
        let context = CIContext(
            options: [
                .useSoftwareRenderer : NSNumber(booleanLiteral: true),
                .cacheIntermediates : NSNumber(booleanLiteral: false)
            ]
        )
        measure {
            let bitmap = getBitmap()

            let oldImage = CIImage(contentsOf: expectedImageUrl)!
            let newImage = CIImage(image: bitmap)!
            let diffOperation = diff(oldImage, newImage)
            let diffOutput = diffOperation.outputImage!

            let diff = maxColorDiff(histogram: histogram(ciImage: diffOutput))
            XCTAssertEqual(0.015625, diff)
        }
        context.clearCaches()
    }
}
