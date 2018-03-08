//  Created by Marton Kerekes on 20/04/2017.

import UIKit

protocol SelectFacebookEventProtocol: class {
    var interactor: SelectFacebookEventInteractor { get set }
    var items: [FacebookEvent]! { get set }
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
}
