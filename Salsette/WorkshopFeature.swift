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
}

fileprivate struct WorkshopInteractor: ContentInteractorInterface {
    fileprivate let dataSource = WorkshopDataSource()
    fileprivate var title: String
    func load(completion: (([ContentEntityInterface])->Void)) {
        completion(dataSource.dummyWorkshops)
    }
}

fileprivate struct WorkshopDataSource {
    fileprivate var dummyWorkshops = [WorkshopEntity(image: UIImage(named: "class")!,
                                                            title: "Mambo",
                                                            organiser: "Adolfo & Tania"),
                                      WorkshopEntity(image: UIImage(named: "class")!,
                                                            title: "Body Movement",
                                                            organiser: "Terry & Cecile"),
                                      WorkshopEntity(image: UIImage(named: "class")!,
                                                     title: "Styling",
                                                     organiser: "Anita")]
}

fileprivate struct WorkshopEntity: ContentEntityInterface {
    var image: UIImage?
    var title: String?
    var organiser: String?
}
