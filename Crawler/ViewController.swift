//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit
import DZNEmptyDataSet
import FBSDKLoginKit

class Presenter {
    lazy var interactor = Interactor()
    weak var view: ViewController?
    init(viewController: ViewController) {
        self.view = viewController
    }
    func viewReady() {
        view?.setModel(.message(NSError(with: "Loading...")))
        interactor.loadEvents { (events, error) in
            self.parseResults(events: events, error: error)
        }
    }
    
    private func parseResults(events: [FacebookEventEntity]?, error: Error?) {
        if let returnedError = error as NSError?, returnedError.code != 8 {
            view?.setModel(.message(returnedError))
        } else if let returnedError = error as NSError?, returnedError.code == 8 {
            view?.setModel(.login)
        } else if let events = events, events.count > 0 {
            view?.setModel(.results(events))
        } else {
            view?.setModel(.message(NSError(with: "No events found")))
        }
    }
}

class Interactor {
    lazy var fbService = FacebookService.shared
    lazy var graphService = GraphManager.shared
    func loadEvents(_ completion: @escaping ([FacebookEventEntity]?, Error?)->()) {
        graphLogin()
        fbService.loadUserEvents { (fbEvents, error) in
            guard let fbEvents = fbEvents else {
                completion(nil, error)
                return
            }
            completion(fbEvents, nil)
        }
    }
    
    private let masterToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1MTk1MDI5NTAsImNsaWVudElkIjoiY2oweTI2eGViMnVtejAxNzIyYzlmcTJxMSIsInByb2plY3RJZCI6ImNqMTN5a3JwazUzMGowMTUycXh1cjM0ZG0iLCJwZXJtYW5lbnRBdXRoVG9rZW5JZCI6ImNqZTFzdG9pZTFrZzAwMTI4dTRvMXAwdTQifQ.SZ6ymhx04g_tFD8eCe9pHmPPbucP-EPNPpTYQ8d-mEs"
    func graphLogin() {
        if !graphService.isLoggedIn {            
                graphService.setToken(masterToken)
        }        
    }
}

class ViewController: UITableViewController {

    var presenter: Presenter?
    @IBOutlet var fbButton: FBSDKLoginButton?
    
    private var fbEvents = [FacebookEventEntity](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var emptyDataSetString: String?
    
    enum Model {
        case results([FacebookEventEntity])
        case message(Error)
        case login
    }
    
    func setModel(_ viewModel: Model) {
        switch viewModel {
        case .results(let events):
            fbEvents = events
        case .message(let error):
            fbEvents = []
            emptyDataSetString = error.localizedDescription
        case .login:
            fbEvents = []
            emptyDataSetString = nil
        }
    }
    
    @objc fileprivate func load() {
        presenter?.viewReady()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbButton?.readPermissions = ["public_profile", "email", "user_friends", "user_events"]
        presenter = Presenter(viewController: self)
        load()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Load", style: .done, target: self, action: #selector(load))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = fbEvents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.location?.graphLocation()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let vc = segue.destination as? CreateEventViewController {
            vc.fbEvent = fbEvents[indexPath.row]
        }
    }
}

extension ViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        guard let emptyDataSetString = emptyDataSetString else { return nil }
        return NSAttributedString(string: emptyDataSetString)
    }

    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if emptyDataSetString != nil { return nil }
        guard let fbButton = fbButton else { return nil }
        return fbButton
    }
}

extension ViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        presenter?.viewReady()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        presenter?.viewReady()
    }
}

