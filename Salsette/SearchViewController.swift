//  Copyright © 2017 Marton Kerekes. All rights reserved.

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

class SearchViewController: UICollectionViewController {
    static let searchSize: CGFloat = 268.0
    @IBOutlet var dateField: HoshiTextField!
    @IBOutlet var locationField: HoshiTextField!
    @IBOutlet var typeField: HoshiTextField!
    @IBOutlet var container: UIStackView!
    @IBOutlet var typePicker: UIPickerView!
    //MARK: - Profile
    @IBOutlet weak var profilePictureView: FBSDKProfilePictureView!
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var loginBtn: FBSDKLoginButton! {
        didSet {
            loginBtn.loginBehavior = .systemAccount
            loginBtn.delegate = self
            loginBtn.readPermissions = ["public_profile", "email", "user_friends", "user_events"]
        }
    }
    
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
    var results = [ContentEntityInterface](){
        didSet {
            collectionView?.reloadData()
        }
    }
    var searchParameters = SearchParameters.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        custumiseDateField()
        customiseLocationField()
        customiseTypeField()
        
        collectionView?.emptyDataSetSource = self
        searchInteractor.load(with: searchParameters)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentCell = sender as? HomeCell,
            let vc = segue.destination as? EventViewController,
            let currentCellIndex = collectionView?.indexPath(for: currentCell) {
            vc.selectedIndex = currentCellIndex
        }
        if let vc = segue.destination as? ProfileViewController, let sender = sender as? UIButton {
            vc.view.backgroundColor = sender.backgroundColor
        }
        if let nav = segue.destination as? UINavigationController,
            let eventViewController = nav.viewControllers.first as? EventViewController,
            let currentCell = sender as? HomeCell,
            let currentCellIndex = collectionView?.indexPath(for: currentCell)
        {
            eventViewController.event = results[currentCellIndex.row]
            eventViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SearchViewController.dismissEventView))
        }
    }
    
    @objc func dismissEventView() {
        dismiss(animated: true)
    }
    
    var emptyDataSetString: String? = nil
    var emptyDataSetCustomView: UIView? = nil
    
    func configure(message: String, view: UIView? = nil) {
        emptyDataSetString = message
        emptyDataSetCustomView = view
        results.removeAll()
        collectionView?.reloadData()
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
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height - (3 * 60) - 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResult", for: indexPath) as? HomeCell)!
        cell.content = results[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case "UICollectionElementKindSectionHeader":
            let suplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchContainer", for: indexPath)
            let layout = collectionView.collectionViewLayout as? SearchResultsCollectionViewLayout
            layout?.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 220)
            suplementaryView.addSubview(container)
            return suplementaryView
        default:
            let suplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchFooter", for: indexPath)
            let layout = collectionView.collectionViewLayout as? SearchResultsCollectionViewLayout
            layout?.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 20)
            return suplementaryView
        }
    }
}

extension SearchViewController {
    
    enum SearchViewModel {
        case name(String)
        case dates(String)
        case location(String)
        case type(String)
    }
    
    func setSearch(_ viewModel: SearchViewModel) {
        switch viewModel {
        case .dates(let dateString):
            dateField.text = dateString
        default:
            return
        }
    }
}

extension SearchViewController {
    enum ResultsViewModel {
        case loading(String)
        case failed(String)
        case needsFacebookLogin(String)
        case success([ContentEntityInterface])
    }
    
    func setResult(_ viewModel: ResultsViewModel) {
        switch viewModel {
        case .loading(let message):
            configure(message: message)
        case .failed(let message):
            configure(message: message)
        case .needsFacebookLogin(let message):
            configure(message: message, view: loginBtn)
        case .success(let items):
            self.results = items
        }
    }
}

extension SearchViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        searchInteractor.load(with: searchParameters)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {       
        searchInteractor.deleteKeychain()
        searchInteractor.load(with: searchParameters)
    }
}

extension SearchViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        guard let emptyDataSetString = emptyDataSetString else { return nil }
        return NSAttributedString(string: emptyDataSetString)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        guard let emptyDataSetCustomView = emptyDataSetCustomView else { return nil }
        return emptyDataSetCustomView
    }
}

fileprivate extension SearchViewController {
    func custumiseDateField() {
        dateField.inputView = calendarView
        dateField.delegate = self
        
        let dateIAV = InputAccessoryView.create(next: { (nextBtn) in
            self.locationField.becomeFirstResponder()
        }, previous: nil, done: { (doneBtn) in
            self.dateField.resignFirstResponder()
            self.searchInteractor.load(with: self.searchParameters)
        })
        dateIAV.prevTitle = nil
        dateField.inputAccessoryView = dateIAV
    }
    
    func customiseLocationField() {
        locationField.inputAccessoryView = InputAccessoryView.create(next: { (nextBtn) in
            self.typeField.becomeFirstResponder()
        }, previous: { (previousBtn) in
            self.dateField.becomeFirstResponder()
        }, done: { (doneBtn) in
            self.locationField.resignFirstResponder()
            self.searchInteractor.load(with: self.searchParameters)
        })
    }
    
    func customiseTypeField() {
        typePicker.delegate = self
        typePicker.dataSource = self
        typeField.inputView = typePicker
        typeField.delegate = self
        let typeIAV = InputAccessoryView.create(next: nil, previous: { (previousBtn) in
            self.locationField.becomeFirstResponder()
        }, done: { (doneBtn) in
            self.typeField.resignFirstResponder()
            self.searchInteractor.load(with: self.searchParameters)
        })
        typeIAV.nextTitle = nil
        typeField.inputAccessoryView = typeIAV
    }
}

