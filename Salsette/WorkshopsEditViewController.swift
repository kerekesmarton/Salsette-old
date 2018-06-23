//  Created by Marton Kerekes on 04/05/2017.

import DZNEmptyDataSet

struct Room {
    var roomName: String {
        return workshops.first?.room ?? "?"
    }
    
    var workshops = [WorkshopModel]()
}

fileprivate extension WorkshopModel {
    func isEqual(to other: WorkshopModel) -> Bool {
        return room == other.room && startTime == other.startTime
    }
}

class WorkshopsEditViewController: UICollectionViewController {
    
    var prefilledWorkshopDate: Date?
    fileprivate var computedItems = [Room]()    
    fileprivate var startTimes = Set<Date>()
    fileprivate var roomNames = Set<String>()
    
    fileprivate func computeEmptyWorkshops(for room: (Room)) -> Room {
        var newRoom = Room(workshops: room.workshops)
        self.startTimes.sorted().forEach { (startTime) in
            if !room.workshops.contains(where: { (workshop) -> Bool in
                return workshop.startTime == startTime
            }) {
                newRoom.workshops.append(WorkshopModel(emptyWorkshopAt: startTime, room: room.roomName))
            }
        }
        newRoom.workshops.sort(by: { (w1, w2) -> Bool in
            w1.startTime < w2.startTime
        })
        return newRoom
    }
    
    fileprivate func createRoom(_ roomName: String) -> Room {
        return Room(workshops: items.filter({ return $0.room == roomName }).sorted(by: { (w1, w2) -> Bool in
            w1.startTime < w2.startTime
        }))
    }
    
    var items = [WorkshopModel](){
        didSet {
            items.forEach( { roomNames.insert($0.room) })
            items.forEach( { startTimes.insert($0.startTime) })
            
            let rooms: [Room] = roomNames.sorted().map { roomName in
                return createRoom(roomName)
            }
            
            computedItems = rooms.map { (room) -> Room in
                return computeEmptyWorkshops(for: room)
            }
            
            guard let layout = collectionView?.collectionViewLayout as? WorkshopsLayout else { return }
            layout.rooms = computedItems
        }
    }
    
    var done: (([WorkshopModel]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //offline testing
//        items = dummyWorkshops()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissAndPerformDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add workshop", style: .done, target: self, action: #selector(addWorkshop))
        title = "Edit Workshops"
        collectionView?.emptyDataSetSource = self
        collectionView?.emptyDataSetDelegate = self
    }
    
    @objc private func addWorkshop() {
        performSegue(withIdentifier: "CreateWorkshopSegue", sender: self)
    }
    
    @objc private func dismissAndPerformDone() {
        done?(items)
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let layout = collectionView?.collectionViewLayout as? WorkshopsLayout else { return }
        layout.rooms = computedItems
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateWorkshopSegue", let vc = segue.destination as? CreateWorkshopViewController {
            vc.rooms = computedItems.compactMap { return $0.roomName }
            if let workshop = sender as? WorkshopModel {
                setup(createWorkshopViewController: vc, with: workshop)
            } else {
                setup(createWorkshopViewController: vc)
            }
        }
    }
    
    fileprivate func deleteAfterFinished(_ workshop: WorkshopModel) {
        if !workshop.isEmpty {
            items.remove(item: workshop)
        }
    }
    
    fileprivate func setup(createWorkshopViewController: CreateWorkshopViewController, with workshop: WorkshopModel) {
        createWorkshopViewController.prefilledWorkshop = workshop
        if workshop.isEmpty {
            createWorkshopViewController.prefilledWorkshop?.startTime = prefilledWorkshopDate!
        }
        createWorkshopViewController.didCreateWorkshop = { newWorkshop in
            self.deleteAfterFinished(workshop)
            self.items.append(newWorkshop)
        }
        createWorkshopViewController.didDeleteWorkshop = {
            self.deleteAfterFinished(workshop)
        }
    }
    
    fileprivate func setup(createWorkshopViewController: CreateWorkshopViewController) {
        createWorkshopViewController.prefilledWorkshopDate = prefilledWorkshopDate
        createWorkshopViewController.didCreateWorkshop = { newWorkshop in
            self.items.append(newWorkshop)
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
        
        if sourceItem.isEqual(to: destinationItem)  {
            return
        }
        
        if !sourceItem.isEmpty {
            items.remove(item: sourceItem)
        }
        if !destinationItem.isEmpty {
            items.remove(item: destinationItem)
        }                
        
        let tempItem = destinationItem
        destinationItem.room = sourceItem.room
        destinationItem.startTime = sourceItem.startTime
        sourceItem.room = tempItem.room
        sourceItem.startTime = tempItem.startTime
        if !sourceItem.isEmpty {
            items.append(sourceItem)
        }
        if !destinationItem.isEmpty {
            items.append(destinationItem)
        }
        collectionView.reloadItems(at: [sourceIndexPath])
    }
}

extension WorkshopsEditViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        return NSAttributedString(string: "Tap to add your first workshop")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.performSegue(withIdentifier: "CreateWorkshopSegue", sender: nil)
    }
}

extension WorkshopsEditViewController {
    fileprivate func dummyWorkshops() -> [WorkshopModel] {
        let date = dummyDate()
        return [WorkshopModel(name: "A1", startTime: date, room: "A"),
                WorkshopModel(name: "A2", startTime: date.addingTimeInterval(3600), room: "A"),
                WorkshopModel(name: "A3", startTime: date.addingTimeInterval(7200), room: "A"),
                WorkshopModel(name: "A4", startTime: date.addingTimeInterval(10800), room: "A"),
                
                WorkshopModel(name: "B1", startTime: date, room: "B"),
                WorkshopModel(name: "B2", startTime: date.addingTimeInterval(3600), room: "B"),
                WorkshopModel(name: "B3", startTime: date.addingTimeInterval(7200), room: "B"),
                
                WorkshopModel(name: "C1", startTime: date.addingTimeInterval(3600), room: "C"),
        ]
    }
    
    private func dummyDate() -> Date {
        return Date().noMinutes()
    }
}
