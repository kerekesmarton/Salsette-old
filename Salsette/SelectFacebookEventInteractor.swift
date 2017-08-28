//
//  SelectFacebookEventInteractor.swift
//  Salsette
//
//  Created by Marton Kerekes on 20/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

protocol SelectFacebookEventProtocol: class {
    var interactor: SelectFacebookEventInteractor { get set }
    var items: [FacebookEventEntity]! { get set }
    func show(error: Error)
}

class SelectFacebookEventInteractor {
    private var facebookService: FacebookService?
    private var imageDownloader: ImageDownloader?
    init(fbService: FacebookService = FacebookService.shared, downloader: ImageDownloader = ImageDownloader.shared) {
        self.facebookService = fbService
        self.imageDownloader = downloader
    }
    
    func prepareForCreatedEvents(with eventView: SelectFacebookEventProtocol) {
        facebookService?.loadUserCreatedEvents(completion: { (results, error) in
            guard let returnedError = error else {
                eventView.items = results
                return
            }
            eventView.show(error: returnedError)
        })
    }
    
    func prepareForSavedEvents(with eventView: SelectFacebookEventProtocol) {
        facebookService?.loadUserEvents(completion: { (results, error) in
            guard let returnedError = error else {
                eventView.items = results
                return
            }
            eventView.show(error: returnedError)
        })
    }

    func cancel() {
        facebookService?.cancel()
    }

    func getImage(for urlString: String?, completion:@escaping ((UIImage)->Void)) {
        imageDownloader?.downloadImage(for: urlString, completion: { (image) in
            completion(image)
        })
    }

    fileprivate func parseEvents(from results: Any?) -> [FacebookEventEntity] {
        guard let parseableResults = results as? [String: Any],
            let events = parseableResults["data"] as? [[String: Any]] else {
                return []
        }
        return events.flatMap({ FacebookEventEntity(with: $0)})
    }
}
