//
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

protocol ContentInteractorInterface {
    func load(with parameters: SearchParameters?, completion: (([ContentEntityInterface])->Void))
}

protocol ContentViewInterface: class {
    var search: GlobalSearch? { get set }
    var interactor: ContentInteractorInterface? { get set }
}

struct EventListFeatureLauncher {
    
    static func configure(_ viewController: ContentViewInterface) {
        viewController.search = GlobalSearch.sharedInstance
        viewController.interactor = EventListInteractor()
    }
}

fileprivate struct EventListInteractor: ContentInteractorInterface {
    fileprivate let dataSource = EventListDataSource()
    fileprivate func load(with parameters: SearchParameters?, completion: (([ContentEntityInterface]) -> Void)) {
        
        let items: [ContentEntityInterface] = HomeTutorial.didShow ? dataSource.dummyEvents() : HomeTutorial.cards
        completion(items)
    }
}

fileprivate struct EventListDataSource {
    fileprivate func dummyEvents () -> [EventEntity] {
            
            let dummyTomorrow = Date().addingTimeInterval(3600*24)
            let dummyDayAfterTomorrow = Date().addingTimeInterval(3600*48)
            let dummynextWeek = Date().addingTimeInterval(3600*24*7)
            let dummyNextWeekPlus = Date().addingTimeInterval(3600*8)
            
            return [EventEntity(organiser: "Adolfo & Tania", name: "Partnerwork", startDate: dummyTomorrow , endDate: dummyDayAfterTomorrow, location: "London", type: .salsa, image: UIImage(named: "party")),
                    EventEntity(organiser: "Adolfo & Tania", name: "Body movement", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Paris", type: EventTypes.bachata, image: UIImage(named: "party")),
                    EventEntity(organiser: "Adolfo & Tania", name: "Spinning", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "London", type: EventTypes.kizomba, image: UIImage(named: "party")),
                    EventEntity(organiser: "Terry & Cecile", name: "Partnerwork", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Milano", type: EventTypes.salsa, image: UIImage(named: "party")),
                    EventEntity(organiser: "Terry & Cecile", name: "Spinning", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "Paris", type: EventTypes.bachata, image: UIImage(named: "party")),
                    EventEntity(organiser: "Adrian & Anita", name: "Partnerwork", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Paris", type: EventTypes.kizomba, image: UIImage(named: "party")),
                    EventEntity(organiser: "Adrian & Anita", name: "Body movement", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "Milano", type: EventTypes.salsa, image: UIImage(named: "party"))]
    }
    
}

fileprivate struct EventEntity: ContentEntityInterface {
    var image: UIImage?
    var organiser: String?
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var type: EventTypes?

    init(organiser: String, name: String, startDate: Date, endDate: Date, location: String, type: EventTypes, image: UIImage?) {
        self.organiser = organiser
        self.name = name
        self.image = image
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.type = type
    }
}
