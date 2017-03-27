//
//  Salsette
//
//  Created by Marton Kerekes on 16/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

fileprivate let contentCellIdentifier = "ContentCell"
enum ContentViewConstants {
    static let margin: CGFloat = 16.0
    static let labelPadding: CGFloat = 56
    static let iPhoneCellFixedHeight: CGFloat = 300
    static let iPadNumberOfCellsPortrait: Int = 3
    static let iPadNumberOfCellsLandscape: Int = 5
    static let iPhoneCellNumberOfCellsLandscape: Int = 3
}

protocol ContentEntityInterface {
    var image: UIImage? { get }
    var title: String? { get }
    var organiser: String? { get }
}

protocol ContentInteractorInterface {
    var title: String {get}
    func load(completion: (([ContentEntityInterface])->Void))
}

class ContentViewController: UICollectionViewController {
 
    var items = [ContentEntityInterface]()
    var interactor: ContentInteractorInterface?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = interactor?.title
        interactor?.load(completion: { items in
            self.items = items
            self.collectionView?.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showMenu(_:)))
    }
    
    var sideMenuViewController: SideMenuViewController?
    func showMenu(_ sender: UIBarButtonItem) {
        let searchViewController = SearchFeatureLauncher.launchSearch()
        sideMenuViewController = SideMenuViewController.create()
        sideMenuViewController?.showSideMenu(in: self, with: searchViewController, sideMenuDidHide: { [weak self] in
            self?.dismiss(animated: false, completion:nil)
            }
        )
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
        cell.titleLabel.text = presentableContent.title
        cell.organiserLabel.text = presentableContent.organiser
        
        return cell
    }
}

class ContentViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organiserLabel: UILabel!
}

class ContentViewLayout: UICollectionViewFlowLayout {
    var idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    
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
