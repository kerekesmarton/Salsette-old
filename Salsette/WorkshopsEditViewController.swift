//
//  Salsette
//
//  Created by Marton Kerekes on 04/05/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

struct Room {
    var roomName: String {
        return workshops.first?.room ?? "?"
    }
    
    var workshops = [GraphWorkshop]()
}

class WorkshopsEditViewController: UICollectionViewController {
    
    var prefilledWorkshopDate: Date?
    fileprivate var computedItems = [Room]()    
    fileprivate var startTimes: Set<Date>?
    fileprivate var roomNames: Set<String>?
    
    var items = [GraphWorkshop](){
        didSet {
            var roomNames = Set<String>()
            var startTimes = Set<Date>()
            
            items.forEach {
                roomNames.insert($0.room)
                startTimes.insert($0.startTime)
            }
            if self.startTimes == nil{
                self.startTimes = startTimes
            }
            if self.roomNames == nil {
                self.roomNames = roomNames
            }
            
            var rooms = [Room]()
            self.roomNames?.sorted().forEach { roomName in
                rooms.append(Room(workshops: items.filter({ return $0.room == roomName }).sorted(by: { (w1, w2) -> Bool in
                    w1.startTime < w2.startTime
                })))
            }
            
            computedItems = rooms.map { (room) -> Room in
                var newRoom = Room(workshops: room.workshops)
                self.startTimes?.sorted().forEach { (startTime) in
                    if !room.workshops.contains(where: { (roomArrangable) -> Bool in
                        return roomArrangable.startTime == startTime
                    }) {
                        newRoom.workshops.append(GraphWorkshop(startTime: startTime, room: room.roomName))
                    }
                }
                newRoom.workshops.sort(by: { (w1, w2) -> Bool in
                    w1.startTime < w2.startTime
                })
                return newRoom
            }
            
            guard let layout = collectionView?.collectionViewLayout as? WorkshopsLayout else { return }
            layout.rooms = computedItems
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //offline testing
//        items = dummyWorkshops()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPrompt))
        title = "Edit Workshops"
        collectionView?.emptyDataSetSource = self
//        collectionViewLayout.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let layout = collectionView?.collectionViewLayout as? WorkshopsLayout else { return }
        layout.rooms = computedItems
        collectionView?.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        startTimes = nil
        roomNames = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateWorkshopSegue", let vc = segue.destination as? CreateWorkshopViewController {
            vc.rooms = computedItems.flatMap { return $0.roomName }
            if let workshop = sender as? GraphWorkshop {
                vc.prefilledWorkshop = workshop
                if workshop.isEmpty {
                    vc.prefilledWorkshop?.startTime = prefilledWorkshopDate!
                }
                vc.createWorkshopDidFinish = { newWorkshop, didDelete in
                    if !workshop.isEmpty {
                        self.items.remove(item: workshop)
                    }
                    guard let createdWorkshop = newWorkshop else { return }
                    self.items.append(createdWorkshop)
                }
            }
        }
    }
}

// MARK: privates

extension WorkshopsEditViewController {
    
    @objc fileprivate func editPrompt() {
        let prompt = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        prompt.addAction(UIAlertAction(title: "Add Workshop", style: .default, handler: { [weak self] (action) in
            self?.addWorkshop()
        }))
        prompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            prompt.dismiss(animated: true, completion: nil)
        }))
        present(prompt, animated: true, completion: nil)
    }
    
    @objc fileprivate func addWorkshop() {
        performSegue(withIdentifier: "CreateWorkshopSegue", sender: self)
    }
}

// MARK: - collection view

extension WorkshopsEditViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return computedItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return computedItems[section].workshops.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = computedItems[indexPath.section].workshops[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkshopCell", for: indexPath)
        guard let workshopCell = cell as? WorkshopCell else {
            return cell
        }
        workshopCell.configure(workshop: item)
        return workshopCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = computedItems[indexPath.section].workshops[indexPath.row]
        self.performSegue(withIdentifier: "CreateWorkshopSegue", sender: item)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RoomCell", for: indexPath) as? RoomCell else {
            return UICollectionViewCell()
        }
        let room = computedItems[indexPath.section];
        cell.nameLbl.text = room.roomName
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var sourceItem = computedItems[sourceIndexPath.section].workshops[sourceIndexPath.row]
        var destinationItem = computedItems[destinationIndexPath.section].workshops[destinationIndexPath.row]
        
        if sourceItem == destinationItem {
            return
        }
        if let sourceIndex = items.index(where: { (item) -> Bool in sourceItem == item }) {
            items.remove(at: sourceIndex)
        }
        
        
        if let destIndex = items.index(where: { (item) -> Bool in destinationItem == item }) {
            items.remove(at: destIndex)
        }
        
        let tempItem = destinationItem
        destinationItem.room = sourceItem.room
        destinationItem.startTime = sourceItem.startTime
        sourceItem.room = tempItem.room
        sourceItem.startTime = tempItem.startTime
        items.append(sourceItem)
        items.append(destinationItem)
        collectionView.reloadItems(at: [sourceIndexPath])
    }
}

extension WorkshopsEditViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let button = UIButton(type: .system)
        button.setTitle("Add first workshop", for: .normal)
        button.addTarget(self, action: #selector(addWorkshop), for: .touchUpInside)
        return button
    }
}

extension WorkshopsEditViewController {
    fileprivate func dummyWorkshops() -> [GraphWorkshop] {
        let date = dummyDate()
        return [GraphWorkshop(name: "A1", startTime: date, room: "A"),
                GraphWorkshop(name: "A2", startTime: date.addingTimeInterval(3600), room: "A"),
                GraphWorkshop(name: "A3", startTime: date.addingTimeInterval(7200), room: "A"),
                GraphWorkshop(name: "A4", startTime: date.addingTimeInterval(10800), room: "A"),
                
                GraphWorkshop(name: "B1", startTime: date, room: "B"),
                GraphWorkshop(name: "B2", startTime: date.addingTimeInterval(3600), room: "B"),
                GraphWorkshop(name: "B3", startTime: date.addingTimeInterval(7200), room: "B"),
                
                GraphWorkshop(name: "C1", startTime: date.addingTimeInterval(3600), room: "C"),
        ]
    }
    
    private func dummyDate() -> Date {
        return Date().noMinutes()
    }
}
