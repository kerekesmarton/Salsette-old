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
        completion(dataSource.dummyEvents)
    }
}

fileprivate struct EventDataSource {
    fileprivate var dummyEvents = [EventEntity(organiser: "organiser", name: "party", image: UIImage(named: "party")!),
                                   EventEntity(organiser: "organiser", name: "party", image: UIImage(named: "party")!),
                                   EventEntity(organiser: "organiser", name: "party", image: UIImage(named: "party")!)]
}

fileprivate struct EventEntity: ContentEntityInterface {
    var image: UIImage?
    var organiser: String?
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var type: String?

    init(organiser: String, name: String, image: UIImage) {
        self.organiser = organiser
        self.name = name
        self.image = image
    }
}
