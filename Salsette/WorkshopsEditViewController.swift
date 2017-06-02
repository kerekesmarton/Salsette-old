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
    let hours: Int = 1
    let startTime: Date
    let room: String
    
    init(name: String, startTime: Date, room: String) {
        self.name = name
        self.startTime = startTime
        self.room = room
    }
    
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = dummyWorkshops()
        guard let layout = collectionView?.collectionViewLayout as? WorkshopsLayout else { return }
        
        layout.rooms = computedItems
    }
    
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
}

extension WorkshopsEditViewController {
    func dummyWorkshops() -> [Workshop] {
        return [Workshop(name: "A1", startTime: Date(timeIntervalSinceNow: 0), room: "A"),
                Workshop(name: "A2", startTime: Date(timeIntervalSinceNow: 60), room: "A"),
                Workshop(name: "A3", startTime: Date(timeIntervalSinceNow: 120), room: "A"),
                Workshop(name: "A1", startTime: Date(timeIntervalSinceNow: 180), room: "A"),
                Workshop(name: "A2", startTime: Date(timeIntervalSinceNow: 240), room: "A"),
                
                Workshop(name: "B1", startTime: Date(timeIntervalSinceNow: 0), room: "B"),
                Workshop(name: "B2", startTime: Date(timeIntervalSinceNow: 60), room: "B"),
                Workshop(name: "B3", startTime: Date(timeIntervalSinceNow: 120), room: "B"),
                
                Workshop(name: "C1", startTime: Date(timeIntervalSinceNow: 120), room: "C"),
        ]
    }
}
