//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

struct EventModel {
    let fbID: String
    let type: Dance
    var id: String? = nil
    var workshops: [WorkshopModel]? = nil
    
    init(fbID: String, type: Dance, id: String? = nil, workshops: [WorkshopModel]? = nil) {
        self.fbID = fbID
        self.type = type
        self.id = id
        self.workshops = workshops
    }
}

struct WorkshopModel: Equatable {
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

func ==(lhs: WorkshopModel, rhs: WorkshopModel) -> Bool {    
    return lhs.id == rhs.id
}
