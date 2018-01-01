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
        view?.state = .loading
        interactor.searchEvent(fbID: fbEvent.identifier) { [weak self] (graphEvent, error) in
            if let graphEvent = graphEvent {
                self?.view?.state = .eventExists(graphEvent)
            } else if let error = error {
                self?.view?.state = .error(error)
            } else {
                self?.view?.state = .newEvent
            }
        }
    }
    
    func shouldProceed() -> Bool {
        if view?.event == nil {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Create event before adding workshops"])
            view?.state = .error(error)
            return false
        } else {
            return true
        }
    }
    
    func createEvent(type: Dance?) {
        guard let fbEvent = view?.fbEvent, let type = type else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Pick an event type"])
            view?.state = .error(error)
            return
        }
        interactor.createEvent(fbID: fbEvent.identifier!, type: type) { [weak self] (graphEvent, error) in
            if let event = graphEvent {
                self?.view?.state = .eventExists(event)
            } else if let error = error {
                self?.view?.state = .error(error)
            } else {
                self?.view?.state = .newEvent
            }
        }
    }
    
    func deleteEvent(event: EventModel) {
        view?.state = .loading
        interactor.deleteEvent(graphID: event.id) { [weak self] (success, error) in
            if let error = error {
                self?.view?.state = .error(error)
            } else {
                self?.view?.state = .deleted
            }
        }
    }
    
    func update(event: EventModel, updated workshops: [WorkshopModel]) {
        view?.state = .loading
        interactor.update(event: event, updated: workshops) { [weak self] (graphEvent, error) in
            if let graphEvent = graphEvent {
                self?.view?.state = .eventExists(graphEvent)
            } else if let error = error {
                self?.view?.state = .error(error)
            } else {
                self?.view?.state = .newEvent
            }
        }
    }
}
