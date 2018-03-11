//  Copyright © 2017 Marton Kerekes. All rights reserved.

import ObjectiveC
import UIKit
import TextFieldEffects
import FBSDKLoginKit
import DZNEmptyDataSet

class SearchViewController: UICollectionViewController {
    static let searchSize: CGFloat = 268.0
    @IBOutlet var dateField: HoshiTextField!
    @IBOutlet var locationField: HoshiTextField!
    @IBOutlet var typeField: HoshiTextField!
    @IBOutlet var container: UIStackView!
    @IBOutlet var typePicker: UIPickerView!
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var loginHostView: UIView!
    @IBOutlet var loginBtn: FBSDKLoginButton! {
        didSet {
            loginBtn.loginBehavior = .systemAccount
            loginBtn.delegate = self
            loginBtn.readPermissions = ["public_profile", "email", "user_friends", "user_events"]
        }
    }
    
    @IBOutlet var retryMessage: UILabel!
    @IBOutlet var retryHostView: UIView!
    
    lazy var calendarProxy: CalendarProxy = {
        return UINib(nibName: "Calendar", bundle: nil).instantiate(withOwner: self, options: nil)[1] as! CalendarProxy
    }()
    
    var calendarView: UIView {
        calendarProxy.delegate = presenter
        return calendarProxy.calendar
    }
    
    lazy var presenter: SearchPresenter = {
       return SearchPresenter(view: self)
    }()
    
    //MARK: - Results
    var results = [SearchResult](){
        didSet {
            collectionView?.reloadData()
        }
    }
    var emptyDataSetString: String? = nil
    var emptyDataSetCustomView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        custumiseDateField()
        customiseLocationField()
        customiseTypeField()
        profileButton.isEnabled = presenter.isProfileEnabled()
        collectionView?.emptyDataSetSource = self
        presenter.viewReady()
    }
    
    @IBAction func retryAction(_ sender: Any) {
        presenter.load()
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return presenter.isProfileEnabled()
    }

    var searchNavigation: UINavigationController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if let profileViewController = segue.destination as? ProfileViewController, let sender = sender as? UIButton {
            profileViewController.view.backgroundColor = sender.backgroundColor
        }
        if let nav = segue.destination as? UINavigationController,
            let eventViewController = nav.viewControllers.first as? EventViewController,
            let currentCell = sender as? ResultCell,
            let currentCellIndex = collectionView?.indexPath(for: currentCell)
        {
            eventViewController.event = results[currentCellIndex.row]
            eventViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SearchViewController.dismissEventView))
        }
        if let nav = segue.destination as? UINavigationController, let searchViewController = nav.viewControllers.first as? LocationSearchViewController {
            searchNavigation = nav
            searchViewController.lowAccuracySearchCompletion = { [weak self] location in
                self?.presenter.load(with: location)
                self?.locationField.text = location.displayableName()
                self?.searchNavigation?.dismiss(animated: true)                
            }
        }
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
        presenter.didChange(type: Dance.item(at: row))
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case dateField:
            presenter.resetDate()
            calendarProxy.deselectAll()
            dateField.resignFirstResponder()
        case locationField:
            locationField.text = ""
            presenter.didChange(location: nil)
        default:
            ()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case typeField:
            let row = typePicker.selectedRow(inComponent: 0)
            typePicker.selectRow(row, inComponent: 0, animated: false)
            typeField.text = Dance.string(at: row)
        case locationField:
            performSegue(withIdentifier: "LocationSearchViewController", sender: self)
        default:
            ()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
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
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResult", for: indexPath) as? ResultCell)!
        cell.event = results[indexPath.item]
        return cell
    }
    
    fileprivate func createHeader(_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView {
        let suplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchContainer", for: indexPath)
        let layout = collectionView.collectionViewLayout as? SearchResultsCollectionViewLayout
        layout?.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 220)
        suplementaryView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: suplementaryView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: suplementaryView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: suplementaryView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: suplementaryView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        return suplementaryView
    }
    
    fileprivate func createFooter(_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView {
        let suplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchFooter", for: indexPath)
        let layout = collectionView.collectionViewLayout as? SearchResultsCollectionViewLayout
        layout?.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 20)
        return suplementaryView
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            return createHeader(collectionView, kind, indexPath)
        } else {
            return createFooter(collectionView, kind, indexPath)
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
        case .dates(let string):
            dateField.text = string
        case .type(let string):
            typeField.text = string
        case .location(let string):
            locationField.text = string
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
        case needsGraphLogin(String)
        case success([SearchResult])
    }
    
    func setResult(_ viewModel: ResultsViewModel) {
        switch viewModel {
        case .loading(let message):
            configure(message: message)
        case .failed(let message):
            configure(message: message, view: retryHostView)
        case .needsFacebookLogin(_):
            configure(message: nil, view: loginHostView)
        case .needsGraphLogin(_):
            graphLogin()
        case .success(let items):
            self.results = items
        }
    }
}

extension SearchViewController: UIPopoverPresentationControllerDelegate {
    
    func graphLogin() {
        
        let loginVC = GraphCreateAccountLauncher().loginViewController(loginCompletion: {
            self.presenter.viewReady()
        })
        
        let popover = loginVC.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = collectionView
        popover?.permittedArrowDirections = .init(rawValue: 0)
        popover?.sourceRect = CGRect(x: collectionView!.bounds.midX, y: collectionView!.bounds.midY, width: 0, height: 0)
        
        present(loginVC, animated: true)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


extension SearchViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        presenter.load()
        profileButton.isEnabled = presenter.isProfileEnabled()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {       
        presenter.didLogout()
        presenter.load()
        profileButton.isEnabled = presenter.isProfileEnabled()
    }
}

extension SearchViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        guard let emptyDataSetString = emptyDataSetString else { return nil }
        return NSAttributedString(string: emptyDataSetString)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if emptyDataSetString != nil { return nil }
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
            self.presenter.load()
        })
        dateIAV.prevTitle = nil
        dateField.inputAccessoryView = dateIAV
    }
    
    func customiseLocationField() {        
        locationField.delegate = self
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
            let selectedRow = self.typePicker.selectedRow(inComponent: 0)
            self.presenter.didChange(type: Dance.item(at: selectedRow))
            self.presenter.load()
        })
        typeIAV.nextTitle = nil
        typeField.inputAccessoryView = typeIAV
    }
    
    @objc func dismissEventView() {
        dismiss(animated: true)
    }
    
    func configure(message: String?, view: UIView? = nil) {
        emptyDataSetString = message
        emptyDataSetCustomView = view
        results.removeAll()
        collectionView?.reloadData()
    }
}
