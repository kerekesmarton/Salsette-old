//
//  Salsette
//
//  Created by Marton Kerekes on 04/05/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct Room {
    var roomName: String? {
        return workshops[0].room
    }
    
    let workshops: [Workshop]
}

struct Workshop {
    let name: String
    let hours: Double = 1
    var startTime: Date
    var room: String
    var artist: String?
    init(name: String, startTime: Date, room: String) {
        self.name = name
        self.startTime = startTime
        self.room = room
    }
    
}

func ==(lhs: Workshop, rhs: Workshop) -> Bool {
    return lhs.room == rhs.room && lhs.startTime == rhs.startTime
}

class WorkshopCell: UICollectionViewCell {
    @IBOutlet var nameLbl: UILabel!
}

class RoomCell: UICollectionReusableView {
    @IBOutlet var nameLbl: UILabel!
}

class WorkshopsEditViewController: UICollectionViewController {
    
    fileprivate var computedItems = [Room]()
    var items = [Workshop](){
        didSet {
            var roomNames = Set<String>()
            items.forEach { roomNames.insert($0.room) }
            
            var rooms = [Room]()
            roomNames.sorted().forEach { roomName in
                rooms.append(Room(workshops: items.filter({ return $0.room == roomName }).sorted(by: { (w1, w2) -> Bool in
                    w1.startTime < w2.startTime
                })))
            }
            
            computedItems = rooms
            guard let layout = collectionView?.collectionViewLayout as? WorkshopsLayout else { return }
            layout.rooms = rooms
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = dummyWorkshops()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPrompt))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(WorkshopsEditViewController.handleLongPress(gesture:)))
        self.collectionView?.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let layout = collectionView?.collectionViewLayout as? WorkshopsLayout else { return }
        layout.rooms = computedItems
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateWorkshopSegue", let vc = segue.destination as? CreateWorkshopViewController {
            vc.rooms = computedItems.flatMap { return $0.roomName }
            vc.createWorkshopDidFinish = {
                workshop in self.items.append(workshop)
            }
        }
    }
}

// MARK: privates

extension WorkshopsEditViewController {
    
    @objc fileprivate func editPrompt() {
        let prompt = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        prompt.addAction(UIAlertAction(title: "Add Workshop", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "CreateWorkshopSegue", sender: self)
            prompt.dismiss(animated: true, completion: nil)
        }))
        prompt.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            self.setEditing(!self.isEditing, animated: true)
            prompt.dismiss(animated: true, completion: nil)
        }))
        prompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            prompt.dismiss(animated: true, completion: nil)
        }))
        present(prompt, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
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
        workshopCell.nameLbl.text = item.name
        return workshopCell
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
//            print("items are equal")
            return
        }
//        print(">>>>starting switch")
//        print(sourceItem)
//        print(destinationItem)
//        
        guard let sourceIndex = items.index(where: { (item) -> Bool in sourceItem == item }) else {
            return
        }
        items.remove(at: sourceIndex)
        
        guard let destIndex = items.index(where: { (item) -> Bool in destinationItem == item }) else {
            return
        }
        items.remove(at: destIndex)
        
        let tempItem = destinationItem
        destinationItem.room = sourceItem.room
        destinationItem.startTime = sourceItem.startTime
        sourceItem.room = tempItem.room
        sourceItem.startTime = tempItem.startTime
        
//        print("after switch")
//        print(sourceItem)
//        print(destinationItem)
        
        items.append(sourceItem)
        items.append(destinationItem)
        
    }
}

extension WorkshopsEditViewController {
    fileprivate func dummyWorkshops() -> [Workshop] {
        return [Workshop(name: "A1", startTime: Date(timeIntervalSinceNow: 0), room: "A"),
                Workshop(name: "A2", startTime: Date(timeIntervalSinceNow: 60), room: "A"),
                Workshop(name: "A3", startTime: Date(timeIntervalSinceNow: 120), room: "A"),
                Workshop(name: "A4", startTime: Date(timeIntervalSinceNow: 180), room: "A"),
                Workshop(name: "A5", startTime: Date(timeIntervalSinceNow: 240), room: "A"),
                
                Workshop(name: "B1", startTime: Date(timeIntervalSinceNow: 0), room: "B"),
                Workshop(name: "B2", startTime: Date(timeIntervalSinceNow: 60), room: "B"),
                Workshop(name: "B3", startTime: Date(timeIntervalSinceNow: 120), room: "B"),
                
                Workshop(name: "C1", startTime: Date(timeIntervalSinceNow: 120), room: "C"),
        ]
    }
}
