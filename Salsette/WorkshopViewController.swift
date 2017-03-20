//
//  WorkshopViewController.swift
//  Salsette
//
//  Created by Marton Kerekes on 20/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class WorkshopViewController: ContentViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //load
    }
}

struct WorkshopInteractor {
    
    func load(completion: (([ContentEntityInterface])->Void)) {
        
        completion([])
    }
}

struct WorkshopDataSource {
    
    fileprivate static var dummyWorkshops = [WorkshopEntity(image: UIImage(named: "class")!,
                                                            title: "Mambo",
                                                            organiser: "Adolfo & Tania"),
                                             WorkshopEntity(image: UIImage(named: "class")!,
                                                            title: "Body Movement",
                                                            organiser: "Terry & Cecile"),]
}

struct WorkshopPresenter {
    
    
}

struct WorkshopEntity: ContentEntityInterface {
    var image: UIImage?
    var title: String?
    var organiser: String?
}
