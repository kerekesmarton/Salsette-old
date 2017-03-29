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
        viewController.interactor = WorkshopInteractor(title: title)
        return viewController
    }
    
    static func launchInNavigation(with title: String) -> UINavigationController {
        let viewController = UIStoryboard.contentViewControllerInNavigation()
        viewController.interactor = WorkshopInteractor(title: title)
        return viewController.navigationController!
    }
}

fileprivate struct WorkshopInteractor: ContentInteractorInterface {
    fileprivate let dataSource = WorkshopDataSource()
    fileprivate var title: String
    func load(completion: (([ContentEntityInterface])->Void)) {
        completion(dataSource.dummyWorkshops)
    }
}

fileprivate struct WorkshopDataSource {
    fileprivate var dummyWorkshops = [WorkshopEntity(organiser: "Adolfo & Tania", name: "Partnerwork", image: UIImage(named: "class")!),
                                      WorkshopEntity(organiser: "Terry & Cecile", name: "Body movement", image: UIImage(named: "class")!),
                                      WorkshopEntity(organiser: "Adrian & Anita", name: "Spinning", image: UIImage(named: "class")!)]
}

fileprivate struct WorkshopEntity: ContentEntityInterface {
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
