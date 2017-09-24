//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

class CreateEventPresenter: NSObject {

    private weak var view: CreateEventViewController?
    private var interactor = CreateEventInteractor()
    
    init(with view: CreateEventViewController) {
        self.view = view
    }
    
    func viewReady() {        
        guard let fbEvent = view?.fbEvent else { return }
        view?.state = CreateEventViewController.ViewState.loading
        interactor.searchEvent(fbID: fbEvent.identifier) { [weak self] (graphEvent, error) in
            if let graphEvent = graphEvent {
                self?.view?.state = CreateEventViewController.ViewState.eventExists(graphEvent)
            } else if let error = error {
                self?.view?.state = CreateEventViewController.ViewState.error(error)
            } else {
                self?.view?.state = CreateEventViewController.ViewState.newEvent
            }
        }
    }
    
    func shouldProceed() -> Bool {
        if view?.graphEvent == nil {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Create event before adding workshops"])
            view?.state = CreateEventViewController.ViewState.error(error)
            return false
        } else {
            return true
        }
    }
    
    func createWorkshop(type: Dance?) {
        guard let fbEvent = view?.fbEvent, let type = type else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Pick an event type"])
            view?.state = CreateEventViewController.ViewState.error(error)
            return
        }
        interactor.createEvent(fbID: fbEvent.identifier!, type: type) { [weak self] (graphEvent, error) in
            if let graphEvent = graphEvent {
                self?.view?.state = CreateEventViewController.ViewState.eventExists(graphEvent)
            } else if let error = error {
                self?.view?.state = CreateEventViewController.ViewState.error(error)
            } else {
                self?.view?.state = CreateEventViewController.ViewState.newEvent
            }
        }
    }
}
