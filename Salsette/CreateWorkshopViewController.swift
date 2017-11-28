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
    fileprivate var timePickerDataSource: TimePickerDataSource?
    
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
        if let startTime = prefilledWorkshop?.startTime {
            timePickerDataSource = TimePickerDataSource(with: timeLbl, values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24], prefilledDate: startTime)
        } else {
            timePickerDataSource = TimePickerDataSource(with: timeLbl, values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24], prefilledDate: prefilledWorkshopDate)
        }
        timeLbl.delegate = self
        let picker = UIPickerView()
        picker.delegate = timePickerDataSource
        picker.dataSource = timePickerDataSource
        timeLbl.inputView = picker        
    }
    
    private func setupButtons() {
        let create = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createWorkshop))
        let delete = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteWorkshop))
        delete.isEnabled = false
        if let ws = prefilledWorkshop, !ws.isEmpty {
            delete.tintColor = UIColor.red
            delete.isEnabled = true
        }
        self.navigationItem.rightBarButtonItems = [create,delete]
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
        guard let name = nameLbl.text, let artist = artistLbl.text, let room = roomLbl.text, let date = timePickerDataSource?.date else { return }
        var workshop = WorkshopModel(name: name, startTime: date, room: room)
        workshop.artist = artist
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
}

extension CreateWorkshopViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == roomLbl, let picker = textField.inputView as? UIPickerView, let prefilledWorkshop = prefilledWorkshop, let i = rooms.index(of: prefilledWorkshop.room) {
            picker.selectRow(i, inComponent: 0, animated: true)
        } else if textField == roomLbl, rooms.count == 0 {
            createNewRoomAlert()
            roomLbl.resignFirstResponder()
        }
        
        if textField == timeLbl,
            let picker = textField.inputView as? UIDatePicker, let prefilledWorkshopDate = prefilledWorkshopDate {
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
}

class TimePickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    init(with lbl: UITextField, values: [Int], prefilledDate: Date?) {
        times = values
        self.lbl = lbl
        date = prefilledDate?.setting(hour: 0)
    }
    
    fileprivate weak var lbl: UITextField?
    fileprivate var times: [Int]
    var date: Date?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(times[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hour = times[row]
        if let startTime = date?.setting(hour: hour) {
            lbl?.text = DateFormatters.timeFormatter.string(from: startTime)
        }
    }
}
