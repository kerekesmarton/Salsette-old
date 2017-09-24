//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

class CreateEventViewController: UITableViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var typeLabel: PickerLabel!
    @IBOutlet var classesLabel: UILabel!
    @IBOutlet var scheduleLabel: UILabel!
    
    var fbEvent: FacebookEventEntity?
    var graphEvent: GraphEvent? {
        didSet {
            selectedEventType = graphEvent?.type
        }
    }
    private var createdItem: ContentEntityInterface?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        eventName.text = fbEvent?.name
        eventLocation.text = fbEvent?.place
        var timeString: String?
        if let startTime = fbEvent?.startDate {
            timeString = DateFormatters.relativeDateFormatter.string(from: startTime)
        }
        if let endTime = fbEvent?.endDate {
            timeString?.append(" to " + DateFormatters.relativeDateFormatter.string(from: endTime))
        }
        eventDate.text = timeString ?? ""
        
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
        }
        )
    }()
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return presenter.shouldProceed()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let workshopsEditVC = segue.destination as? WorkshopsEditViewController {
            workshopsEditVC.prefilledWorkshopDate = fbEvent?.startDate?.noHours()
            guard let workshops = graphEvent?.workshops else { return }
            workshopsEditVC.items = workshops
        }
    }
    
    @objc private func create() {
        presenter.createWorkshop(type: selectedEventType)
    }
    
    @objc private func update() {
        
    }
    
    enum ViewState {
        case eventExists(GraphEvent)
        case newEvent
        case error(Error)
        case loading
    }
    
    var state: ViewState? = nil {
        didSet {
            switch state! {
            case .error(let error):
                showError(error)
            case .eventExists(let event):
                showLoading(false, nil, nil)
                graphEvent = event
                createWorkshopButton()
            case .newEvent:
                showLoading(false, nil, nil)
                createWorkshopButton()
            case .loading:
                showLoading(true, "Fetching event", nil)
            }
        }
    }
    
    private func showLoading(_ active: Bool, _ message: String?, _ completion: (() -> Void)?) {
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
    
    private func createWorkshopButton() {
        if graphEvent == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(create))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
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
    }
}
