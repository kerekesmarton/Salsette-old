//
//  WorkshopViewController.swift
//  Salsette
//
//  Created by Marton Kerekes on 20/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct WorkshopFeatureLauncher {
    static func launch(with title: String) -> ContentViewController {
        let viewController = UIStoryboard.contentViewController()
        configure(viewController, with: title)
        return viewController
    }
    
    static func launchInNavigation(with title: String) -> UINavigationController {
        let viewController = UIStoryboard.contentViewControllerInNavigation()
        configure(viewController, with: title)
        return viewController.navigationController!
    }
    
    static func configure(_ viewController: ContentViewController, with title: String) {
        viewController.search = GlobalSearch.sharedInstance
        viewController.interactor = WorkshopInteractor(title: title)
    }
}

class WorkshopViewController: ContentViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        WorkshopFeatureLauncher.configure(self, with: "Workshops")
    }
}

fileprivate struct WorkshopInteractor: ContentInteractorInterface {
    fileprivate let dataSource = WorkshopDataSource()
    fileprivate var title: String
    fileprivate func load(with parameters: SearchParameters?, completion: (([ContentEntityInterface]) -> Void)) {
        completion(dataSource.dummyWorkshops())
    }
}

fileprivate struct WorkshopDataSource {
    fileprivate func dummyWorkshops () -> [WorkshopEntity
        ] {
        
        let dummyTomorrow = Date().addingTimeInterval(3600*24)
        let dummyDayAfterTomorrow = Date().addingTimeInterval(3600*48)
        let dummynextWeek = Date().addingTimeInterval(3600*24*7)
        let dummyNextWeekPlus = Date().addingTimeInterval(3600*8)
        
        return [WorkshopEntity(organiser: "Adolfo & Tania", name: "Partnerwork", startDate: dummyTomorrow , endDate: dummyDayAfterTomorrow, location: "London", type: EventTypes.salsa, image: UIImage(named: "class")),
                WorkshopEntity(organiser: "Adolfo & Tania", name: "Body movement", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Paris", type: EventTypes.bachata, image: UIImage(named: "class")),
                WorkshopEntity(organiser: "Adolfo & Tania", name: "Spinning", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "London", type: EventTypes.kizomba, image: UIImage(named: "class")),
                WorkshopEntity(organiser: "Terry & Cecile", name: "Partnerwork", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Milano", type: EventTypes.kizomba, image: UIImage(named: "class")),
                WorkshopEntity(organiser: "Terry & Cecile", name: "Spinning", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "Paris", type: EventTypes.bachata, image: UIImage(named: "class")),
                WorkshopEntity(organiser: "Adrian & Anita", name: "Partnerwork", startDate: dummynextWeek, endDate: dummyNextWeekPlus, location: "Paris", type: EventTypes.salsa, image: UIImage(named: "class")),
                WorkshopEntity(organiser: "Adrian & Anita", name: "Body movement", startDate: dummyTomorrow, endDate: dummyDayAfterTomorrow, location: "Milano", type: EventTypes.salsa, image: UIImage(named: "class"))]
    }
}

fileprivate struct WorkshopEntity: ContentEntityInterface {
    
    var image: UIImage?
    var organiser: String
    var name: String
    var startDate: Date
    var endDate: Date
    var location: String
    var type: EventTypes

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
