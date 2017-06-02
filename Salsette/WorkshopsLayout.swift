
import UIKit

class WorkshopsLayout: UICollectionViewLayout {
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

        // 3: Calculate the width available for cells
        let itemsWidth = collectionView!.bounds.width
            - collectionView!.contentInset.left
            - collectionView!.contentInset.right
            - headerWidth;
        
        var columnX: CGFloat = 0
        
        // 4: For each day
        for (roomIndex, room) in rooms.enumerated() {
            
            // 4.1: Find the X coordinate of the row
            columnX = CGFloat(roomIndex) * (rowHeight + horizontalDividerHeight)
            
            // 4.2: Generate and store layout attributes header cell
            let headerIndexPath = IndexPath(item: 0, section: roomIndex)

            let headerCellAttributes =
                UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                    with: headerIndexPath)
            
            headerAttributes[headerIndexPath] = headerCellAttributes

            headerCellAttributes.frame = CGRect(x: 0, y: columnX, width: headerWidth, height: rowHeight)
            
            // 4.3: Get the total number of hours for the day
            let hoursInDay = room.workshops.reduce(0) { (h, e) in h + e.hours }
            
            // Set the initial X position for time entry cells
            var cellX = headerWidth
            
            // 4.4: For each time entry in day
            for (entryIndex, entry) in room.workshops.enumerated() {
                
                // 4.4.1: Get the width of the cell
                var cellWidth = CGFloat(Double(entry.hours) / Double(hoursInDay)) * itemsWidth
                
                // Leave some empty space to form the vertical divider
                cellWidth -= verticalDividerWidth
                cellX += verticalDividerWidth
                
                // 4.4.3: Generate and store layout attributes for the cell
                let cellIndexPath = IndexPath(item: entryIndex, section: roomIndex)
                let timeEntryCellAttributes =
                    UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
                
                cellAttributes[cellIndexPath] = timeEntryCellAttributes
                
                timeEntryCellAttributes.frame = CGRect(x: cellX, y: columnX, width: cellWidth, height: rowHeight)
                
                // Update cellX to the next starting position
                cellX += cellWidth
            }
        }
        
        // 5: Store the complete content size
        let maxY = columnX + rowHeight
        contentSize = CGSize(width: collectionView!.bounds.width, height: maxY)
        
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
