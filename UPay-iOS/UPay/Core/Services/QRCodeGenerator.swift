import CoreImage.CIFilterBuiltins
import UIKit

enum QRCodeGenerator {
    static func makeImage(from value: String, scale: CGFloat = 8) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(value.utf8)
        filter.correctionLevel = "M"

        guard let output = filter.outputImage else { return nil }

        let transformed = output.transformed(
            by: CGAffineTransform(scaleX: scale, y: scale)
        )

        return UIImage(ciImage: transformed)
    }
}
