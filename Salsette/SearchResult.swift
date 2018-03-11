//
//  SearchResult.swift
//  Salsette
//
//  Created by Marton Kerekes on 11/03/2018.
//  Copyright © 2018 Marton Kerekes. All rights reserved.
//

import UIKit

struct SearchResult {
    let graphEvent: EventModel
    var fbEvent: FacebookEvent?
    
    init(graphEvent: EventModel) {
        self.graphEvent = graphEvent
    }
    
    static func results(with events: [EventModel]?) -> [SearchResult] {
        guard let events = events else { return [] }
        return events.map({ (event) -> SearchResult in
            return SearchResult(graphEvent: event)
        })
    }
}

extension SearchResult {
    var name: String {
        return graphEvent.name
    }
    
    var location: String? {
        return fbEvent?.location?.displayableAddress() ?? graphEvent.place?.displayableAddress()
    }
    
    var place: String? {
        return fbEvent?.place ?? graphEvent.place?.displayableName()
    }
    
    var identifier: String {
        return graphEvent.fbID
    }
    
    var startDate: String? {
        guard let date = fbEvent?.startDate else { return graphEvent.date }
        return DateFormatters.relativeDateFormatter.string(from: date)
    }
    
    var endDate: String? {
        guard let date = fbEvent?.endDate else { return nil }
        return DateFormatters.relativeDateFormatter.string(from: date)
    }
    
    var image: UIImage? {
        return fbEvent?.image
    }
    
    var imageUrl: String? {
        return fbEvent?.imageUrl
    }
    
    var longDescription: String? {
        return fbEvent?.longDescription
    }
}
