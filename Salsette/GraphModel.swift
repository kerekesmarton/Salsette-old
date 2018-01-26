//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

public struct EventModel {
    let fbID: String
    let type: Dance
    let name: String
    let date: String
    var id: String? = nil
    var workshops: [WorkshopModel]? = nil
    var place: PlaceModel? = nil
    
    init(fbID: String, type: Dance, name: String, date: String, id: String? = nil, place: PlaceModel? = nil, workshops: [WorkshopModel]? = nil) {
        self.fbID = fbID
        self.type = type
        self.name = name
        self.date = date
        self.id = id
        self.place = place
        self.workshops = workshops
    }
}

public struct WorkshopModel: Equatable {
    var room: String
    var startTime: Date
    var artist: String? = nil
    var name: String
    var eventID: String? = nil
    var id: String
    
    init(room: String, startTime: Date, artist: String, name: String, eventID: String? = nil, id: String?) {
        self.room = room
        self.startTime = startTime
        self.artist = artist
        self.name = name
        self.eventID = eventID
        guard let id = id else {
            self.id = "temp"+ProcessInfo.processInfo.globallyUniqueString
            return
        }
        self.id = id
    }
    
    init(name: String, startTime: Date, room: String) {
        self.name = name
        self.startTime = startTime
        self.room = room
        self.id = "temp"+ProcessInfo.processInfo.globallyUniqueString
    }
    
    init(emptyWorkshopAt startTime: Date, room: String) {
        name = ""
        self.startTime = startTime
        self.room = room
        self.id = "temp"+ProcessInfo.processInfo.globallyUniqueString
    }
    
    var isEmpty: Bool {
        return name.count == 0
    }
    
    var isTemporary: Bool {
        return id.starts(with: "temp")
    }
    
    var startTimeToStr: String {
        return DateFormatters.graphDateTimeFormatter.string(from: startTime)
    }
    
    static func dateTime(from str: String) -> Date {
        return DateFormatters.graphDateTimeFormatter.date(from: str)!
    }
}

public func ==(lhs: WorkshopModel, rhs: WorkshopModel) -> Bool {    
    return lhs.id == rhs.id
}

struct PlaceModel {
    var address: String
    var city: String
    var country: String
    var lat: Double
    var lon: Double
    var name: String
    var zip: String
    init(address: String, city: String, country: String, lat: Double, lon: Double, name: String, zip: String) {
        self.address = address
        self.city = city
        self.country = country
        self.lat = lat
        self.lon = lon
        self.name = name
        self.zip = zip
    }
    
    init?(fbPlace: FacebookLocation?) {
        guard let address = fbPlace?.address, let name = fbPlace?.name, let city = fbPlace?.city, let country = fbPlace?.country, let zip = fbPlace?.zip, let lat: String = fbPlace?.lat, let lon: String = fbPlace?.lon, let cLat = Double(lat), let cLon = Double(lon) else {
            return nil
        }
        self.address = address
        self.city = city
        self.country = country
        self.lat = cLat
        self.lon = cLon
        self.name = name
        self.zip = zip
    }
}
