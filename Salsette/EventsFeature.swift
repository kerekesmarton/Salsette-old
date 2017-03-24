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
}

fileprivate struct EventInteractor: ContentInteractorInterface {
    fileprivate let dataSource = EventDataSource()
    fileprivate var title: String
    func load(completion: (([ContentEntityInterface])->Void)) {
        completion(dataSource.dummyEvents)
    }
}

fileprivate struct EventDataSource {
    fileprivate var dummyEvents = [EventEntity(image: UIImage(named: "party")!,
                                                     title: "Friday Party",
                                                     organiser: "London"),
                                      EventEntity(image: UIImage(named: "party")!,
                                                     title: "Saturday Party",
                                                     organiser: "Milano"),]
}

fileprivate struct EventEntity: ContentEntityInterface {
    var image: UIImage?
    var title: String?
    var organiser: String?
}
