//
//  SelectFacebookEventInteractor.swift
//  Salsette
//
//  Created by Marton Kerekes on 20/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

protocol SelectFacebookEventProtocol: class {
    var items: [FacebookEventEntity] { get set }
    func show(error: Error)
    var interactor: SelectFacebookEventInteractor? { get set }
}

class SelectFacebookEventInteractor {
    private weak var view: SelectFacebookEventProtocol?
    private var facebookService: FacebookService?
    private var imageDownloader: ImageDownloader?
    init(with view: SelectFacebookEventProtocol, fbService: FacebookService, downloader: ImageDownloader) {
        self.view = view
        self.facebookService = fbService
        self.imageDownloader = downloader
    }

    func prepare(from viewController: UIViewController) {

        facebookService?.getUserEvents(from: viewController, completion: { [weak self] (result, error) in
            guard let returnedError = error else {
                self?.updateView(with: result)
                return
            }
            self?.view?.show(error: returnedError)
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

    private func updateView(with results: Any?) {
        view?.items = parseEvents(from: results)
    }

    fileprivate func parseEvents(from results: Any?) -> [FacebookEventEntity] {
        guard let parseableResults = results as? [String: Any],
            let events = parseableResults["data"] as? [[String: Any]] else {
                return []
        }
        return events.flatMap({ FacebookEventEntity(with: $0)})
    }
}
