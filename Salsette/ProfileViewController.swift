//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit
import FBSDKLoginKit
import Auth0
import ChameleonFramework

class ProfileViewController: UITableViewController {

    enum ViewStates {
        case displayName(String)
        case loading(Bool, String?, (() -> Void)?)
        case error(Error)
        case userReady(Bool)
    }
    
    var interactor: ProfileInteractor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        interactor = ProfileInteractor(with: self)
    }
    
    //offline testing
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        set(viewState: .userReady(true))
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatWhite
        interactor?.viewReady()
    }

    func set(viewState: ViewStates) {
        DispatchQueue.main.async { [weak self] in
            switch viewState {
            case .displayName(let displayName):
                self?.displayName = displayName
            case .loading(let value, let message, let completion):
                self?.showLoading(value, message, completion)
            case .error(let error):
                self?.showError(error)
            case .userReady(let isReady):
                self?.userIsReady = isReady
                self?.tableView.reloadData()
            }
        }
    }

    fileprivate func showLoading(_ active: Bool, _ message: String?, _ completion: (() -> Void)?) {
        if active {
            self.present(UIAlertController.loadingAlert(with: message), animated: false, completion: completion)
        } else {
            self.dismiss(animated: false, completion: completion)
        }
    }

    private func showError(_ error: Error) {
        showLoading(false, nil, nil)
        self.present(UIAlertController.errorAlert(with: error), animated: false, completion: nil)
    }

    fileprivate var userIsReady: Bool = false
    fileprivate var displayName: String?
}

extension ProfileViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIsReady ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        default:
            return 150
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCellIdentifiers.allIdentifiers[indexPath.section])!
        switch indexPath.section {
        case 0:
            guard let imageCell = cell as? UserCell else { return cell }
            if userIsReady {
                interactor?.loadImage(with: { (image) in
                    imageCell.profilePictureView?.image = image
                })
                imageCell.userNameLabel?.text = displayName
            } else {
                imageCell.profilePictureView?.image = nil
                imageCell.userNameLabel?.text = nil
            }            
        case 1:
            guard let eventsCell = cell as? EventsCell else { return cell }
            eventsCell.configureForSavedEvents()
        case 2:
            guard let eventsCell = cell as? EventsCell else { return cell }
            eventsCell.configureForCreatedEvents()
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !userIsReady {
            return nil
        }
        switch section {
        case 0:
            return nil
        case 1:
            return "Saved events"
        case 2:
            return "Created events"
        default:
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? EventCollectionViewCell, let vc = segue.destination as? EventViewController {
            vc.event = cell.item
        } else if let cell = sender as? EventCollectionViewCell, let vc = segue.destination as? CreateEventViewController {
            vc.fbEvent = cell.item
        }
    }
}
