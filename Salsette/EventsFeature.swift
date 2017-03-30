//
//  EventsFeature.swift
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct EventFeatureLauncher {
    
    static func launch(with title: String) -> ContentViewController {
        let viewController = UIStoryboard.contentViewController()
        viewController.interactor = EventInteractor(title: title)
        return viewController
    }
    
    static func launchInNavigation(with title: String) -> UINavigationController {
        let viewController = UIStoryboard.contentViewControllerInNavigation()
        viewController.interactor = EventInteractor(title: title)
        return viewController.navigationController!
    }
}

fileprivate struct EventInteractor: ContentInteractorInterface {
    fileprivate let dataSource = EventDataSource()
    fileprivate var title: String
    func load(completion: (([ContentEntityInterface])->Void)) {
        completion(dataSource.dummyEvents())
    }
}

fileprivate struct EventDataSource {
    fileprivate func dummyEvents () -> [EventEntity] {
            
            let dummyTomorrow = Date().addingTimeInterval(3600*24)
            let dummyDayAfterTomorrow = Date().addingTimeInterval(3600*48)
            let dummynextWeek = Date().addingTimeInterval(3600*24*7)
            let dummyNextWeekPlus = Date().addingTimeInterval(3600*8)
            
            return [EventEntity(organiser: "Adolfo & Tania", name: "Partnerwork", startDate: dummyTomorrow , endDate: dummyDayAfterTomorrow, location: "London", image: UIImage(named: "party")),
                    EventEntity(organiser: "Adolfo & Tania", name: "Body movement", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Paris", image: UIImage(named: "party")),
                    EventEntity(organiser: "Adolfo & Tania", name: "Spinning", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "London", image: UIImage(named: "party")),
                    EventEntity(organiser: "Terry & Cecile", name: "Partnerwork", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Milano", image: UIImage(named: "party")),
                    EventEntity(organiser: "Terry & Cecile", name: "Spinning", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "Paris", image: UIImage(named: "party")),
                    EventEntity(organiser: "Adrian & Anita", name: "Partnerwork", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Paris", image: UIImage(named: "party")),
                    EventEntity(organiser: "Adrian & Anita", name: "Body movement", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "Milano", image: UIImage(named: "party"))]
    }
    
}

fileprivate struct EventEntity: ContentEntityInterface {
    var image: UIImage?
    var organiser: String
    var name: String
    var startDate: Date
    var endDate: Date
    var location: String
    var type: EventTypes

    init(organiser: String, name: String, startDate: Date, endDate: Date, location: String, image: UIImage?) {
        self.organiser = organiser
        self.name = name
        self.image = image
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.type = .party
    }
}
