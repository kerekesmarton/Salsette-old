//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

class CreateEventViewController: UITableViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var typeLabel: PickerLabel!
    @IBOutlet var classesLabel: UILabel!
    @IBOutlet var scheduleLabel: UILabel!
    
    var fbEvent: FacebookEventEntity?
    var event: EventModel? {
        didSet {
            selectedEventType = event?.type
        }
    }
    private var createdItem: SearchableEntity?
    fileprivate var selectedEventType: Dance? {
        didSet {
            typeLabel.text = selectedEventType?.rawValue
        }
    }
    private var imageDownloader = ImageDownloader.shared
    private var presenter: CreateEventPresenter!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presenter = CreateEventPresenter(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = fbEvent?.name
        hostLabel.text = fbEvent?.place
        if let time = fbEvent?.startDate {
            startDate.text = DateFormatters.relativeDateFormatter.string(from: time)
        }
        if let time = fbEvent?.endDate {
            endDate.text = DateFormatters.relativeDateFormatter.string(from: time)
        } else {
            endDate.text = ""
        }
        placeLabel.text = fbEvent?.location?.displayableName()
        locationLabel.text = fbEvent?.location?.displayableAddress()
        descriptionLabel.text = fbEvent?.longDescription
        
        let picker = UIPickerView()
        typeLabel.inputView = picker
        typeLabel.inputAccessoryView = iav
        picker.delegate = self
        picker.dataSource = self
        
        let size = imageView.frame.size
        imageDownloader.downloadImage(for: fbEvent?.imageUrl, completion: { [weak self] (image) in
            self?.imageView?.image = image.fit(intoSize:size)
        })
        
        presenter.viewReady()
    }
    
    lazy var iav: UIView = {
        InputAccessoryView.create(next: nil, previous: nil, done: { _ in
            self.typeLabel.resignFirstResponder()
        })
    }()
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return presenter.shouldProceed()
    }

    var searchNavigation: UINavigationController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let workshopsEditVC = nav.viewControllers.first as? WorkshopsEditViewController {
            
            workshopsEditVC.prefilledWorkshopDate = fbEvent?.startDate?.noHours()
            workshopsEditVC.done = { [weak self] items in
                guard let event = self?.event else { return }
                self?.presenter.update(event: event, updated: items)
            }
            guard let workshops = event?.workshops else { return }
            workshopsEditVC.items = workshops
        }
        if let nav = segue.destination as? UINavigationController, let searchVC = nav.viewControllers.first as? LocationSearchViewController, let fbLocation = sender as? FacebookLocation {
            searchVC.fbLocation = fbLocation
            searchNavigation = nav
            searchVC.completion = { [weak self] placeModel in
                let newLocation = FacebookLocation(with: placeModel)
                self?.fbEvent?.location = newLocation
                self?.searchNavigation?.dismiss(animated: true)
            }
        }
    }
    
    @objc private func create() {
        guard let startDate = fbEvent?.startDate  else {
            return
        }
        let date = DateFormatters.facebookDateFormatter.string(from: startDate)
        presenter.createEvent(type: selectedEventType, name: fbEvent?.name, time: date, place: fbEvent?.location as? FacebookLocation)
    }
    
    @objc private func deleteEvent() {
        guard let event = event else { return }
        presenter.deleteEvent(event: event)
    }
    
    enum ViewState {
        case eventExists(EventModel)
        case newEvent
        case missingName
        case missingType
        case missingLocation(FacebookLocation?)
        case missingDate
        case error(Error)
        case loading
        case deleted
    }
    
    var state: ViewState? = nil {
        didSet {
            switch state! {
            case .error(let error):
                showError(error)
            case .eventExists(let existingEvent):
                showLoading(false, nil, nil)
                event = existingEvent
                createWorkshopButton()
            case .newEvent:
                showLoading(false, nil, nil)
                createWorkshopButton()
            case .loading:
                showLoading(true, "Fetching event", nil)
            case .deleted:
                showLoading(false, nil, nil)
                navigationController?.popViewController(animated: true)
            case .missingType:
                activateTypeLabel()
            case .missingDate:
                ()
            case .missingName:
                ()
            case .missingLocation(let fbLocation):
                performSegue(withIdentifier: "LocationSearchViewController", sender: fbLocation)
            }
        }
    }
    
    private weak var alert: UIAlertController? = nil
    private func showLoading(_ active: Bool, _ message: String?, _ completion: (() -> Void)?) {
        if active {
            let alert = UIAlertController.loadingAlert(with: message)
            present(alert, animated: false, completion: completion)
            self.alert = alert
        } else {
            alert?.dismiss(animated: false)
        }
    }
    
    private func showError(_ error: Error) {
        showLoading(false, nil, nil)
        self.present(UIAlertController.errorAlert(with: error), animated: false, completion: nil)
    }
    
    private func createWorkshopButton() {
        if event == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(create))
        } else {
            let delete = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteEvent))
            delete.tintColor = .red
            self.navigationItem.rightBarButtonItem = delete
        }
    }
}

extension CreateEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        selectedEventType = Dance.item(at: row)
    }
}

extension CreateEventViewController {
    
    func activateTypeLabel() {
        typeLabel.becomeFirstResponder()
        guard let selectedEventType = selectedEventType,
            let index = Dance.allDanceTypes.index(of: selectedEventType)
            else {
                self.selectedEventType = Dance.item(at: 0)
                return
        }
        let picker = typeLabel.inputView as? UIPickerView
        picker?.selectRow(index, inComponent: 0, animated: false)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            performSegue(withIdentifier: "LocationSearchViewController", sender: fbEvent?.location)
        case 4:
            activateTypeLabel()
        default:
            ()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 250
        case 7:
            guard let desc = fbEvent?.longDescription else { return 0 }
            return desc.height(withConstrainedWidth: tableView.frame.width - (tableView.contentInset.left + tableView.contentInset.right), font: UIFont.systemFont(ofSize: 18))
        default:
            return 60
        }
    }
}
