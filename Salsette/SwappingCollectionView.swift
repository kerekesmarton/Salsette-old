//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension CGPoint {
    func distanceToPoint(p:CGPoint) -> CGFloat {
        return sqrt(pow((p.x - x), 2) + pow((p.y - y), 2))
    }
}

struct SwapDescription : Hashable {
    var firstItem : Int
    var secondItem : Int
    
    var hashValue: Int {
        get {
            return (firstItem * 10) + secondItem
        }
    }
}

func ==(lhs: SwapDescription, rhs: SwapDescription) -> Bool {
    return lhs.firstItem == rhs.firstItem && lhs.secondItem == rhs.secondItem
}

class SwappingCollectionView: UICollectionView {
    
    var interactiveIndexPath : IndexPath?
    var interactiveView : UIView?
    var interactiveCell : UICollectionViewCell?
    var swapSet : Set<SwapDescription> = Set()
    var previousPoint : CGPoint?
    
    static let distanceDelta:CGFloat = 2 // adjust as needed
    
    override func beginInteractiveMovementForItem(at indexPath: IndexPath) -> Bool {
        
        interactiveIndexPath = indexPath
        
        interactiveCell = cellForItem(at: indexPath)
        
        interactiveView = UIImageView(image: interactiveCell?.snapshot())
        interactiveView?.frame = interactiveCell!.frame
        
        addSubview(interactiveView!)
        bringSubview(toFront: interactiveView!)
        
        interactiveCell?.isHidden = true
        
        return true
    }
    
    override func updateInteractiveMovementTargetPosition(_ targetPosition: CGPoint) {
        
        if (shouldSwap(newPoint: targetPosition)) {
            
            if let hoverIndexPath = indexPathForItem(at: targetPosition), let interactiveIndexPath = interactiveIndexPath {
                let swapDescription = SwapDescription(firstItem: interactiveIndexPath.item, secondItem: hoverIndexPath.item)
                
                if (!swapSet.contains(swapDescription)) {
                    
                    swapSet.insert(swapDescription)
                    
                    performBatchUpdates({
                        self.moveItem(at: interactiveIndexPath, to: hoverIndexPath)
                        self.moveItem(at: hoverIndexPath, to: interactiveIndexPath)
                    }, completion: {(finished) in
                        self.swapSet.remove(swapDescription)
                        self.dataSource?.collectionView?(self, moveItemAt: interactiveIndexPath, to: hoverIndexPath)
                        self.interactiveIndexPath = hoverIndexPath
                    })
                }
            }
        }
        
        interactiveView?.center = targetPosition
        previousPoint = targetPosition
    }
    
    override func endInteractiveMovement() {
        if let interactiveIndexPath = interactiveIndexPath {
                reloadItems(at: [interactiveIndexPath])
        }
        cleanup()
    }
    
    override func cancelInteractiveMovement() {
        cleanup()
    }
    
    func cleanup() {
        interactiveCell?.isHidden = false
        interactiveView?.removeFromSuperview()
        interactiveView = nil
        interactiveCell = nil
        interactiveIndexPath = nil
        previousPoint = nil
        swapSet.removeAll()
    }
    
    func shouldSwap(newPoint: CGPoint) -> Bool {
        if let previousPoint = previousPoint {
            let distance = previousPoint.distanceToPoint(p: newPoint)
            return distance < SwappingCollectionView.distanceDelta
        }
        
        return false
    }
}
