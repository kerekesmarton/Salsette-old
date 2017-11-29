//
//  CreateWorkshopViewController.swift
//  Salsette
//
//  Created by Marton Kerekes on 03/06/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import TextFieldEffects

class CreateWorkshopViewController: UITableViewController {
    
    @IBOutlet var nameLbl: HoshiTextField!
    @IBOutlet var artistLbl: HoshiTextField!
    @IBOutlet var roomLbl: HoshiTextField!
    @IBOutlet var timeLbl: HoshiTextField!
    fileprivate var roomPickerDataSource: RoomPickerDataSource?
    var timePicker: UIDatePicker!
    
    var rooms = [String]()
    var createWorkshopDidFinish: ((WorkshopModel?, Bool)->Void)?
    var prefilledWorkshop: WorkshopModel?
    var prefilledWorkshopDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoomLbl()
        setupButtons()
        setupTimeLbl()
        prefill()
        title = "Create Workshop"
    }
    
    private func setupRoomLbl() {
        roomPickerDataSource = RoomPickerDataSource(with: self, lbl: roomLbl, values: rooms)
        roomLbl.delegate = self
        let picker = UIPickerView()
        picker.delegate = roomPickerDataSource
        picker.dataSource = roomPickerDataSource
        roomLbl.inputView = picker
    }
    
    func setupTimeLbl() {
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        if let startTime = prefilledWorkshop?.startTime {
            timePicker.date = startTime
        } else {
            timePicker.date = prefilledWorkshopDate!
        }
        timePicker.minuteInterval = 30
        timeLbl.delegate = self
        timeLbl.inputView = timePicker
        timePicker.addTarget(self, action: #selector(timePickerDidChange(value:)), for: .valueChanged)
    }
    
    private func setupButtons() {
        let delete = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteWorkshop))
        delete.isEnabled = false
        if let ws = prefilledWorkshop, !ws.isEmpty {
            delete.tintColor = UIColor.red
            delete.isEnabled = true
        }
        if prefilledWorkshop != nil {
            let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(createWorkshop))
            self.navigationItem.rightBarButtonItems = [save,delete]
        } else {
            let create = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createWorkshop))
            self.navigationItem.rightBarButtonItems = [create,delete]
        }
    }
    
    private func prefill() {
        guard let prefilledWorkshop = prefilledWorkshop else {
            return
        }
        roomLbl.text = prefilledWorkshop.room
        timeLbl.text = DateFormatters.relativeDateFormatter.string(from: prefilledWorkshop.startTime)
        nameLbl.text = prefilledWorkshop.name        
    }
    
    @objc func createWorkshop() {
        guard let name = nameLbl.text, let artist = artistLbl.text, let room = roomLbl.text, let date = timePicker?.date else { return }
        timeLbl.text = DateFormatters.timeFormatter.string(from: timePicker.date)
        let workshop = WorkshopModel(room: room, startTime: date, artist: artist, name: name)
        createWorkshopDidFinish?(workshop, false)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteWorkshop() {
        let alert = UIAlertController(title: "Delete workshop?", message: "This cannot be reverted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
            self.createWorkshopDidFinish?(nil, true)
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAction) in
            self.createWorkshopDidFinish?(nil, true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func createNewRoomAlert() {
        let alert = UIAlertController(title: "Room name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
            guard let textField = alert.textFields?[0], let text = textField.text else { return }
            if !self.rooms.contains(text) {
                self.rooms.append(text)
                self.roomLbl?.text = text
                self.timeLbl?.becomeFirstResponder()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in () }))
        alert.addTextField(configurationHandler: { _ in () })
        present(alert, animated: true, completion: nil)
    }
    
    @objc func timePickerDidChange(value: Any) {
        timeLbl.text = DateFormatters.timeFormatter.string(from: timePicker.date)
    }
}

extension CreateWorkshopViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == roomLbl, let picker = textField.inputView as? UIPickerView, let prefilledWorkshop = prefilledWorkshop, let i = rooms.index(of: prefilledWorkshop.room) {
            picker.selectRow(i, inComponent: 0, animated: true)
        } else if textField == roomLbl, rooms.count == 0 {
            createNewRoomAlert()
            roomLbl.resignFirstResponder()
        }
        
        if textField == timeLbl, let picker = textField.inputView as? UIDatePicker, let prefilledWorkshopDate = prefilledWorkshopDate {
            picker.setDate(prefilledWorkshopDate, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameLbl:
            artistLbl.becomeFirstResponder()
        case artistLbl:
            roomLbl.becomeFirstResponder()
        default: ()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case timeLbl:
            return false
        case roomLbl:
            return false
        default:
            return true
        }
    }
}

class RoomPickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    init(with controller: CreateWorkshopViewController, lbl: UITextField, values: [String]) {
        rooms = values
        rooms.append("New Room")
        self.controller = controller
        self.lbl = lbl
    }
    
    fileprivate weak var controller: CreateWorkshopViewController?
    fileprivate weak var lbl: UITextField?
    fileprivate var rooms: [String]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rooms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rooms[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if rooms[row] == "New Room" {
            controller?.createNewRoomAlert()
        } else {
            lbl?.text = rooms[row]
        }
    }
    
    func createRoom() {
        let alert = UIAlertController(title: "Room name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
            guard let textField = alert.textFields?[0], let text = textField.text else { return }
            if !self.rooms.contains(text) {
                self.rooms.append(text)
                self.lbl?.text = text
                self.lbl?.resignFirstResponder()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in () }))
        alert.addTextField(configurationHandler: { _ in () })
        controller?.present(alert, animated: true, completion: nil)
    }
}
