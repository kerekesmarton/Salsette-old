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
    var createWorkshopDidFinish: ((Workshop)->Void)?
    var prefilledWorkshop: Workshop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoomLbl()
        setupDone()
        setupTimeLbl()
        prefill()
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
        timePickerDataSource = TimePickerDataSource(with: self, lbl: timeLbl, values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24])
        timeLbl.delegate = self
        let picker = UIPickerView()
        picker.delegate = timePickerDataSource
        picker.dataSource = timePickerDataSource
        timeLbl.inputView = picker        
    }
    
    private func setupDone() {
        let btn = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createWorkshop))
        self.navigationItem.rightBarButtonItem = btn
    }
    
    private func prefill() {
        guard let prefilledWorkshop = prefilledWorkshop else {
            return
        }
        roomLbl.text = prefilledWorkshop.room
        timeLbl.text = DateFormatters.relativeDateFormatter.string(from: prefilledWorkshop.startTime)
        nameLbl.text = prefilledWorkshop.name        
    }
    func createWorkshop() {
        guard let name = nameLbl.text, let artist = artistLbl.text, let room = roomLbl.text else { return }
        var workshop = Workshop(name: name, startTime: Date(), room: room)
        workshop.artist = artist
        createWorkshopDidFinish?(workshop)
        navigationController?.popViewController(animated: true)
    }
}

extension CreateWorkshopViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == roomLbl,
            let picker = textField.inputView as? UIPickerView,
            let prefilledWorkshop = prefilledWorkshop,
            let i = rooms.index(of: prefilledWorkshop.room) {
                picker.selectRow(i, inComponent: 0, animated: true)
        }
        
        if textField == timeLbl,
            let picker = textField.inputView as? UIDatePicker, let prefilledWorkshop = prefilledWorkshop {
                picker.setDate(prefilledWorkshop.startTime, animated: true)
        }
    }
}

class RoomPickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    init(with controller: UIViewController, lbl: UITextField, values: [String]) {
        rooms = values
        rooms.append("New Room")
        self.controller = controller
        self.lbl = lbl
    }
    
    fileprivate weak var controller: UIViewController?
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
        } else {
            lbl?.text = rooms[row]
        }
    }
}

class TimePickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    init(with lbl: UITextField, values: [Int]) {
        times = values
        self.lbl = lbl
    }
    
    fileprivate weak var lbl: UITextField?
    fileprivate var times: [Int]
    
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
        lbl?.text = String(times[row])
    }
}
