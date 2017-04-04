
import UIKit
import CoreGraphics

public extension UIImage {
    
    public class func resizableImage(_ color: UIColor, cornerRadius: CGFloat) -> UIImage {
        let size = CGSize(width: 2 * cornerRadius + 1, height:2 * cornerRadius + 1)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0),
                          size: size)
        let bezierPath = UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        UIGraphicsGetCurrentContext()?.clear(rect)
        color.setFill()
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    }

    private func scale(to goalSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(goalSize, true, 1.0)
        self.draw(in: CGRect(origin: .zero, size: goalSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }

    func fit(intoSize targetSize: CGSize) -> UIImage {
        let sizeBeingScaledTo = CGSize.aspectFit(aspectRatio: self.size, targetBoundingSize: targetSize)
        return self.scale(to: sizeBeingScaledTo)
    }

    func fill(intoSize targetSize: CGSize) -> UIImage {
        let sizeBeingScaledTo = CGSize.aspectFill(aspectRatio: self.size, targetMinimumSize: targetSize)
        return self.scale(to: sizeBeingScaledTo)
    }
    
    func convertToGrayScale() -> UIImage? {
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = self.size.width
        let height = self.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        guard let cgImage = self.cgImage else {
            return nil
        }
        context?.draw(cgImage, in: imageRect)
        let imageRef = context?.makeImage()
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage
    }
}
