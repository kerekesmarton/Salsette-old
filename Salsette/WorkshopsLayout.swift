
import UIKit

class WorkshopsLayout: UICollectionViewFlowLayout {
    fileprivate var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    fileprivate var headerAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    fileprivate var contentSize: CGSize?    
    fileprivate let numberOfVisibleItems: CGFloat = 4.5
    fileprivate let headerWidth = CGFloat(80)
    fileprivate let verticalDividerWidth = CGFloat(2)
    fileprivate let horizontalDividerHeight = CGFloat(2)
    
    var rooms = [Room]() {
        didSet {
            invalidateLayout()
        }
    }
    
    fileprivate func clearCache() {
        cellAttributes.removeAll()
        headerAttributes.removeAll()
    }
    
    fileprivate var wsDuration: CGFloat = 1.0
    
    fileprivate var rowHeight: CGFloat {
        let availableHeight = collectionView!.bounds.height
            - collectionView!.contentInset.top
            - collectionView!.contentInset.bottom
            - (numberOfVisibleItems - wsDuration) * horizontalDividerHeight
        
        return availableHeight / numberOfVisibleItems
    }
    
    fileprivate var headerHeight: CGFloat {
        return rowHeight / 2
    }
    
    fileprivate var rowWidth: CGFloat {
        let availableWidth = collectionView!.bounds.width
            - collectionView!.contentInset.left
            - collectionView!.contentInset.right
            - CGFloat(rooms.count - 1) * horizontalDividerHeight
        return availableWidth / CGFloat(rooms.count)
    }
    
    fileprivate var columnX: CGFloat = 0
    fileprivate var maxY: CGFloat = 0
    
    fileprivate func headerCellAttribute(at headerIndexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let headerCellAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: headerIndexPath)
        headerCellAttributes.frame = CGRect(x: columnX, y: 0, width: rowWidth, height: headerHeight)
        return headerCellAttributes
    }
    
    fileprivate var cellHeight: CGFloat {
        return rowHeight - verticalDividerWidth
    }
    
    fileprivate func wsCellAttributes(_ cellIndexPath: IndexPath, at cellY: CGFloat) -> UICollectionViewLayoutAttributes {
        let wsCellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
        wsCellAttributes.frame = CGRect(x: columnX, y: cellY, width: rowWidth, height: cellHeight)
        return wsCellAttributes
    }
    
    override func prepare() {
        
        clearCache()
        
        for (roomIndex, room) in rooms.enumerated() {
            
            columnX = CGFloat(roomIndex) * (rowWidth + horizontalDividerHeight)
            let headerIndexPath = IndexPath(item: 0, section: roomIndex)
            headerAttributes[headerIndexPath] = headerCellAttribute(at: headerIndexPath)
            
            // Set the initial Y position for workshop cells
            var cellY = headerHeight
            
            // 4.3: For each time entry in day
            for (wsIndex, _) in room.workshops.enumerated() {
                
                cellY += verticalDividerWidth
                
                // 4.3.2: Generate and store layout attributes for the cell
                let cellIndexPath = IndexPath(item: wsIndex, section: roomIndex)
                cellAttributes[cellIndexPath] = wsCellAttributes(cellIndexPath, at: cellY)
                
                // Update cellX to the next starting position
                cellY += cellHeight
            }
            maxY = max(maxY, cellY)
        }
        
        // 5: Store the complete content size
        let maxX = columnX + rowWidth
        
        contentSize = CGSize(width: maxX, height: maxY)
    }
        
    override var collectionViewContentSize : CGSize {
        if contentSize != nil {
            return contentSize!
        }
        return CGSize.zero
    }

    override func layoutAttributesForElements(in rect: CGRect) ->
        [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()

        for attribute in headerAttributes.values {
            if attribute.frame.intersects(rect) {
                attributes.append(attribute)
            }
        }

        for attribute in cellAttributes.values {
            if attribute.frame.intersects(rect) {
                attributes.append(attribute)
            }
        }
            
        return attributes

    }

    override func layoutAttributesForItem(at indexPath: IndexPath) ->
        UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath]
    }

    override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return headerAttributes[indexPath]
    }
}
