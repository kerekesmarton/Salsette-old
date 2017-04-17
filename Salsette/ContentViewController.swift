//
//  Salsette
//
//  Created by Marton Kerekes on 16/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

protocol ContentInteractorInterface {
    var title: String {get}
    func load(with parameters: SearchParameters?, completion: (([ContentEntityInterface])->Void))
}

@objc protocol ContentLayoutDelegate: class {
    func heightForHeader()->CGFloat
}

class ContentViewController: UICollectionViewController, ContentLayoutDelegate {
    fileprivate let contentCellIdentifier = "ContentCell"
    var search: GlobalSearch?
    var isSearching = true {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    var items = [ContentEntityInterface]()
    var interactor: ContentInteractorInterface?
    lazy var searchViewController: SearchViewController = {
        return SearchFeatureLauncher.launchSearch()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        search?.searchResultsDelegate = self
        load()
    }
    
    func load() {
        interactor?.load(with: search?.searchParameters,  completion: { items in
            self.items = items
            self.collectionView?.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let layout = collectionView?.collectionViewLayout as? ContentViewLayout else { return }
        layout.sizeDelegate = self
    }

    func showMenu() {
        isSearching = true
    }
    
    func hideMenu() {
//        isSearching = false
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let presentableContent = items[indexPath.row]
        let cell: ContentViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellIdentifier, for: indexPath) as! ContentViewCell
        
        cell.imageView.image = presentableContent.image
        cell.titleLabel.text = presentableContent.name
        cell.organiserLabel.text = presentableContent.organiser
//        cell.timeLabel.text = DateFormatters.dateFormatter.string(from: presentableContent.startDate)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView: ContentSearchBar = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ContentSearchBar", for: indexPath) as! ContentSearchBar
            if isSearching {
                guard let childView = searchViewController.view else { return UICollectionReusableView() }
                headerView.addToContainer(childView: childView)
                self.addChildViewController(searchViewController)
                searchViewController.didMove(toParentViewController: self)
            } else {
                searchViewController.view.removeFromSuperview()
                searchViewController.didMove(toParentViewController: nil)
            }
            return headerView
        }
        
        return UICollectionReusableView()
    }

    func heightForHeader() -> CGFloat {
        return isSearching ? SearchViewController.searchSize : 60.0
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isSearching {
            hideMenu()
        }
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y < 0 && !isSearching{
            showMenu()
        }
    }
}

extension ContentViewController: SearchResultsDelegate {
    func didUpdateSearch(parameters: SearchParameters) {
        load()
    }
}

class ContentSearchBar: UICollectionReusableView {
    func addToContainer(childView: UIView) {
        self.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = true
        childView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        childView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        childView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        childView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

class ContentViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organiserLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
}

class ContentViewLayout: UICollectionViewFlowLayout {
    enum ContentViewConstants {
        static let margin: CGFloat = 16.0
        static let labelPadding: CGFloat = 56
        static let iPhoneCellFixedHeight: CGFloat = 340
        static let iPadNumberOfCellsPortrait: Int = 3
        static let iPadNumberOfCellsLandscape: Int = 5
        static let iPhoneCellNumberOfCellsLandscape: Int = 3
    }
    var idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    weak var sizeDelegate: ContentLayoutDelegate?
    override func prepare() {
        scrollDirection = .vertical
        minimumLineSpacing = idiom == .pad ? 16 : 0
        minimumInteritemSpacing = idiom == .pad ? 16 : 0
        sectionInset = UIEdgeInsets(top: minimumLineSpacing, left: minimumLineSpacing, bottom: self.minimumLineSpacing, right: minimumLineSpacing)
        switch idiom {
        case .phone:
            let cellSize = calculateDynamicCellSize(forCells: numberOfCellPerRow(), padding: 0, margin: 0)
            self.itemSize = CGSize(width: cellSize, height: CGFloat(ContentViewConstants.iPhoneCellFixedHeight))
        default:
            let cellSize = calculateDynamicCellSize(forCells: numberOfCellPerRow(), padding: minimumLineSpacing, margin: ContentViewConstants.margin)
            self.itemSize = CGSize(width: cellSize, height: cellSize + CGFloat(ContentViewConstants.labelPadding))
        }
        headerReferenceSize = CGSize(width: itemSize.width, height: sizeDelegate?.heightForHeader() ?? 60)
        super.prepare()
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if collectionView?.bounds.width == newBounds.width {
            return false
        }
        return true
    }
    
    func numberOfCellPerRow() -> CGFloat {
        switch idiom {
        case .phone:
            return CGFloat(UIDevice.current.orientation.isLandscape ? ContentViewConstants.iPhoneCellNumberOfCellsLandscape : 1)
        case .pad:
            return CGFloat(UIDevice.current.orientation.isLandscape ? ContentViewConstants.iPadNumberOfCellsLandscape : ContentViewConstants.iPadNumberOfCellsPortrait)
        default:
            return 1.0
        }
    }
    
    func calculateDynamicCellSize(forCells numberOfCellsPerRow: CGFloat, padding: CGFloat, margin: CGFloat) -> CGFloat {
        guard let width = collectionView?.bounds.width else {
            return 0
        }
        
        let totalMarginWidth = (numberOfCellsPerRow - 1) * padding
        return floor(((width - (2 * margin)) - totalMarginWidth) / numberOfCellsPerRow)
    }
}
