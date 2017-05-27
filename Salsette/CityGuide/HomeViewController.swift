//
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class HomeViewController: UIViewController, ContentViewInterface {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePictureView: FBSDKProfilePictureView!
    @IBOutlet var profileButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var results = [ContentEntityInterface]()
    var search: GlobalSearch?
    var interactor: ContentInteractorInterface?
    
    override func awakeFromNib() {
        EventListFeatureLauncher.configure(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentCell = sender as? HomeCell,
            let vc = segue.destination as? EventViewController,
            let currentCellIndex = collectionView.indexPath(for: currentCell) {
            vc.selectedIndex = currentCellIndex
        }
        if let vc = segue.destination as? ProfileViewController, let sender = sender as? UIButton {
            sender.heroID = "selected"
            vc.view.heroModifiers = [.source(heroID: "selected")]
            vc.view.backgroundColor = sender.backgroundColor
        }
        if let eventViewController = segue.destination as? EventViewController,
            let currentCell = sender as? HomeCell,
            let currentCellIndex = collectionView.indexPath(for: currentCell) {
            eventViewController.events = results
            eventViewController.selectedIndex = currentCellIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileButton.addSubview(profilePictureView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        search?.searchResultsDelegate = self
        load()
    }
    
    func load() {
        interactor?.load(with: search?.searchParameters,  completion: { items in
            self.results = items
            self.collectionView?.reloadData()
        })
    }
}

extension HomeViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? HomeCell)!
        cell.content = results[indexPath.item]
        
        return cell
    }
}

extension HomeViewController: SearchResultsDelegate {
    func didUpdateSearch(parameters: SearchParameters) {
        
        if let type = parameters.type {
            switch type {
            case .any:
                typeLabel.text = "Your next adventure awaits"
            default:
                typeLabel.text = "\(String(describing: type)) awaits"
            }
        }
        
        if let location = parameters.location {
            typeLabel.text = location
        }
        
        if let date = parameters.startDate {
            dateLabel.text = DateFormatters.dayMonthFormatter.string(from: date)
        }
        
        load()
    }
}
