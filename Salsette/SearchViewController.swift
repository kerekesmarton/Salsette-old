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
import DZNEmptyDataSet

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
    var search = GlobalSearch.shared
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
//        navigationController?.customizeTransparentNavigationBar()
        
        let dateIAV = InputAccessoryView.create(next: { (nextBtn) in
            self.locationField.becomeFirstResponder()
        }, previous: nil, done: { (doneBtn) in
            self.dateField.resignFirstResponder()
            self.load()
        })
        dateIAV.prevTitle = nil
        dateField.inputAccessoryView = dateIAV
       
        locationField.inputAccessoryView = InputAccessoryView.create(next: { (nextBtn) in
            self.typeField.becomeFirstResponder()
        }, previous: { (previousBtn) in
            self.dateField.becomeFirstResponder()
        }, done: { (doneBtn) in
            self.locationField.resignFirstResponder()
            self.load()
        })
        let typeIAV = InputAccessoryView.create(next: nil, previous: { (previousBtn) in
            self.locationField.becomeFirstResponder()
        }, done: { (doneBtn) in
            self.typeField.resignFirstResponder()
            self.load()
        })
        typeIAV.nextTitle = nil
        typeField.inputAccessoryView = typeIAV
        collectionView.emptyDataSetSource = self
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
            vc.view.backgroundColor = sender.backgroundColor
        }
        if let nav = segue.destination as? UINavigationController,
            let eventViewController = nav.viewControllers.first as? EventViewController,
            let currentCell = sender as? HomeCell,
            let currentCellIndex = collectionView.indexPath(for: currentCell)
        {
            eventViewController.event = results[currentCellIndex.row]
            eventViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SearchViewController.dismissEventView))
        }
    }
    
    @objc func dismissEventView() {
        dismiss(animated: true)
    }
    
    var emptyDataSetString = "You can start a search by setting some of the above fields"
    func load() {
        self.configureAndReload(message: "Loading...")
        resultsInteractor.load(with: search.searchParameters,  completion: { items, errorString in
            guard let returnedItems = items else {
                if let errorMessage = errorString {
                    self.configureAndReload(message: errorMessage)
                } else {
                    self.configureAndReload(message: "Couldn't find anything... \nSorry about that.")
                }
                return
            }
            self.results.append(contentsOf: returnedItems)
            self.collectionView?.reloadData()
        })
    }
    
    func configureAndReload(message: String) {
        self.emptyDataSetString = message
        self.results.removeAll()
        self.collectionView?.reloadData()
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
        return Dance.allDanceTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Dance.string(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeField.text = Dance.string(at: row)
        searchInteractor.didChange(.type(Dance.item(at: row)))
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case typeField:
            let row = typePicker.selectedRow(inComponent: 0)
            typePicker.selectRow(row, inComponent: 0, animated: false)
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

extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            return 60
        default:
            return tableView.frame.height - (3 * 60)
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: tableView.frame.height - (3 * 60) - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? HomeCell)!
        cell.content = results[indexPath.item]
        
        return cell
    }
}

extension SearchViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetString)
    }
}

