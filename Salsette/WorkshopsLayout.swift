
import UIKit

class WorkshopsLayout: UICollectionViewFlowLayout {
    fileprivate var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    fileprivate var headerAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    fileprivate var contentSize: CGSize?
    
    fileprivate let numberOfVisibleItems = 4.5
    fileprivate let headerWidth = CGFloat(80)
    fileprivate let verticalDividerWidth = CGFloat(2)
    fileprivate let horizontalDividerHeight = CGFloat(2)
    
    var rooms = [Room]() {
        didSet {
            invalidateLayout()
        }
    }
    
    override func prepare() {
        
        // 1: Clear the cache
        cellAttributes.removeAll()
        headerAttributes.removeAll()
        
        // 2: Calculate the height of a row
        let availableHeight = collectionView!.bounds.height
            - collectionView!.contentInset.top
            - collectionView!.contentInset.bottom
            - CGFloat(numberOfVisibleItems - 1) * horizontalDividerHeight
        
        let rowHeight = availableHeight / CGFloat(numberOfVisibleItems)
        let headerHeight = rowHeight / 2
        // 3: Calculate the width available for cells
        let availableWidth = collectionView!.bounds.width
            - collectionView!.contentInset.left
            - collectionView!.contentInset.right
            - CGFloat(rooms.count - 1) * horizontalDividerHeight
        
        let rowWidth = availableWidth / CGFloat(rooms.count)
        
        var columnX: CGFloat = 0
        var maxY: CGFloat = 0
        
        // 4: For each day
        for (roomIndex, room) in rooms.enumerated() {
            
            // 4.1: Find the X coordinate of the column
            columnX = CGFloat(roomIndex) * (rowWidth + horizontalDividerHeight)
            
            // 4.2: Generate and store layout attributes header cell
            let headerIndexPath = IndexPath(item: 0, section: roomIndex)
            let headerCellAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: headerIndexPath)
            headerAttributes[headerIndexPath] = headerCellAttributes
            headerCellAttributes.frame = CGRect(x: columnX, y: 0, width: rowWidth, height: headerHeight)
            
            // Set the initial Y position for workshop cells
            var cellY = headerHeight
            
            // 4.3: For each time entry in day
            for (wsIndex, workshop) in room.workshops.enumerated() {
                
                // 4.3.1: Get the height of the cell
                var cellHeight = CGFloat(workshop.hours) * rowHeight
                
                // Leave some empty space to form the vertical divider
                cellHeight -= verticalDividerWidth
                cellY += verticalDividerWidth
                
                // 4.3.2: Generate and store layout attributes for the cell
                let cellIndexPath = IndexPath(item: wsIndex, section: roomIndex)
                let timeEntryCellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
                
                cellAttributes[cellIndexPath] = timeEntryCellAttributes
                
                timeEntryCellAttributes.frame = CGRect(x: columnX, y: cellY, width: rowWidth, height: cellHeight)
                
                // Update cellX to the next starting position
                cellY += cellHeight
            }
            maxY = max(maxY, cellY)
        }
        
        // 5: Store the complete content size
        let maxX = columnX + rowWidth
        
        contentSize = CGSize(width: maxX, height: maxY)
        
        print("collectionView size = \(NSStringFromCGSize(collectionView!.bounds.size))")
        print("contentSize = \(NSStringFromCGSize(contentSize!))")
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
            
        print("layoutAttributesForElementsInRect rect = \(NSStringFromCGRect(rect)), returned \(attributes.count) attributes")
        
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
