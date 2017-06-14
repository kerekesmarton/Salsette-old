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
    
    var rooms = [String]()
    var createWorkshopDidFinish: ((Workshop)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoomLbl()
        setupDone()
    }
    
    fileprivate var roomPickerDataSource: [String] {
        var temp = rooms
        temp.append("New Room")
        return temp
    }
    
    private func setupRoomLbl() {
        roomLbl.delegate = self
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        roomLbl.inputView = picker
    }
    private func setupDone() {
        let btn = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createWorkshop))
        self.navigationItem.rightBarButtonItem = btn
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        default:
            ()
        }
    }
}

extension CreateWorkshopViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roomPickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roomPickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if roomPickerDataSource[row] == "New Room" {
            let alert = UIAlertController(title: "Room name?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                guard let textField = alert.textFields?[0], let text = textField.text else { return }
                if !self.rooms.contains(text) {
                    self.rooms.append(text)
                    self.roomLbl.text = text
                    self.roomLbl.resignFirstResponder()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in () }))
            alert.addTextField(configurationHandler: { _ in () })
            present(alert, animated: true, completion: nil)
        } else {
            roomLbl.text = rooms[row]
        }
    }
}
