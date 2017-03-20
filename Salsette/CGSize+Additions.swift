
import UIKit

extension CGSize {
    static func aspectFit(aspectRatio: CGSize, targetBoundingSize: CGSize) -> CGSize {
        var boundingSize = targetBoundingSize
        let mW = boundingSize.width / aspectRatio.width
        let mH = boundingSize.height / aspectRatio.height

        if mH < mW {
            boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width
        } else if mW < mH {
            boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height
        }

        return boundingSize
    }

    static func aspectFill(aspectRatio: CGSize, targetMinimumSize: CGSize) -> CGSize {
        var minimumSize = targetMinimumSize
        let mW = minimumSize.width / aspectRatio.width
        let mH = minimumSize.height / aspectRatio.height

        if mH > mW {
            minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width
        } else if mW > mH {
            minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height
        }

        return minimumSize
    }
}
