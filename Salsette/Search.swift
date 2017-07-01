//
//  ViewController.swift
//  Salsette
//
//  Created by Marton Kerekes on 08/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import ObjectiveC
import UIKit
import TextFieldEffects
import FBSDKLoginKit

protocol SearchResultsDelegate: class {
    func didUpdateSearch(parameters: SearchParameters)
}

struct SearchParameters {
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var type: EventTypes?
}

class GlobalSearch {
    private init() { }
    static let sharedInstance = GlobalSearch()
    weak var searchResultsDelegate: SearchResultsDelegate?
    var searchParameters = SearchParameters() {
        didSet {
            searchResultsDelegate?.didUpdateSearch(parameters: searchParameters)
        }
    }
}

struct SearchFeatureLauncher {

    static func launchSearch() -> SearchViewController {
        let searchViewController = UIStoryboard.searchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter)
        searchViewController.searchInteractor = interactor
        presenter.searchView = searchViewController
        
        return searchViewController
    }
}

class SearchViewController: UITableViewController {
    static let searchSize: CGFloat = 268.0
//    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var dateField: HoshiTextField!
    @IBOutlet weak var locationField: HoshiTextField!
    @IBOutlet weak var typeField: HoshiTextField!
    @IBOutlet var fields: [UITextField]!
    @IBOutlet var typePicker: UIPickerView!
    
    lazy var calendarProxy: CalendarProxy = {
        return UINib(nibName: "Calendar", bundle: nil).instantiate(withOwner: self, options: nil)[1] as! CalendarProxy
    }()
    
    var calendarView: UIView {
        calendarProxy.interactor = self.searchInteractor
        return calendarProxy.calendar
    }
    
    lazy var searchInteractor: SearchInteractor = {
        let interactor = SearchInteractor(presenter: SearchPresenter())
        interactor.searchPresenter.searchView = self
        return interactor
    }()
    
    //MARK: - Results
    @IBOutlet weak var collectionView: UICollectionView!
    var results = [ContentEntityInterface]()
    var search: GlobalSearch?
    var resultsInteractor: ContentInteractorInterface = {
        return HomeInteractor()
    }()
    
    //MARK: - Profile
    @IBOutlet weak var profilePictureView: FBSDKProfilePictureView!
    @IBOutlet var profileButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.inputView = calendarView
        typeField.inputView = typePicker
        typePicker.delegate = self
        typePicker.dataSource = self
        typeField.delegate = self
        dateField.delegate = self
        navigationController?.customizeTransparentNavigationBar()
        dateField.inputAccessoryView = InputAccessoryView.create(next: { (nextBtn) in
            self.locationField.becomeFirstResponder()
        }, previous: nil, done: { (doneBtn) in
            self.locationField.becomeFirstResponder()
        })
        locationField.inputAccessoryView = InputAccessoryView.create(next: { (nextBtn) in
            self.typeField.becomeFirstResponder()
        }, previous: nil, done: { (doneBtn) in
            self.typeField.becomeFirstResponder()
        })
        typeField.inputAccessoryView = InputAccessoryView.create(next: { (nextBtn) in
            self.typeField.resignFirstResponder()
        }, previous: nil, done: { (doneBtn) in
            self.typeField.resignFirstResponder()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        search?.searchResultsDelegate = self
        load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fields.forEach({$0.endEditing(true)})
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
    
    func load() {
        resultsInteractor.load(with: search?.searchParameters,  completion: { items, error in
            
            guard let returnedItems = items else {
                if let returnedError = error {
                    let alert = UIAlertController(title: "Could not load results", message: returnedError.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                }
                return
            }
            self.results = returnedItems
            self.collectionView?.reloadData()
        })
    }
    
    func profile() {
        performSegue(withIdentifier: "Profile", sender: profilePictureView)
    }
}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventTypes.allEventTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {        
        return EventTypes.string(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeField.text = EventTypes.string(at: row)
        searchInteractor.didChange(.type(EventTypes.item(at: row)))
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case locationField:
            searchInteractor.didChange(.location(locationField.text!))
        default:
            ()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case dateField:
            locationField.becomeFirstResponder()
        case locationField:
            typeField.becomeFirstResponder()
        case typeField:
            typeField.resignFirstResponder()
        default:
            ()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == typeField || textField == dateField {
            return false
        }
        return true
    }
}

extension SearchViewController {
    
    enum SearchViewModel {
        case name(String)
        case dates(String)
        case location(String)
        case typde(String)
    }
    
    func set(_ viewModel: SearchViewModel) {     
        switch viewModel {
        case .dates(let dateString):
            dateField.text = dateString
        default:
            return
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? HomeCell)!
        cell.content = results[indexPath.item]
        
        return cell
    }
}

extension SearchViewController: SearchResultsDelegate {
    func didUpdateSearch(parameters: SearchParameters) {        
        load()
    }
}


