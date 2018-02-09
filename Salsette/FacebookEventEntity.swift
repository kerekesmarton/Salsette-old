//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

class FacebookLocation: SearchableLocation {
    
    var city: String?
    var country: String?
    var address: String?
    var name: String?
    var zip: String?

    init(with placeModel: PlaceModel) {
        self.address = placeModel.address
        self.city = placeModel.city
        self.country = placeModel.country
        self.name = placeModel.name
        self.zip = placeModel.zip
    }

    init(){}
    
    static func location(from json: JSON) -> FacebookLocation {
        let location = FacebookLocation()
        location.name = json["name"].string
        location.zip = json["location"]["zip"].string
        location.city = json["location"]["city"].string
        location.address = json["location"]["street"].string
        location.country = json["location"]["country"].string
        
        return location
    }
    
    func displayableName() -> String? {
        return name
    }
    
    public func graphLocation() -> String? {
        return city
    }
    
    func displayableAddress() -> String? {
        guard let city = city, let address = address, let zip = zip else { return nil }
        return "\(zip), \(city), \(address)"
    }
}

class FacebookEventEntity: SearchableEntity, Equatable, Hashable {
    var name: String?
    var place: String?
    var location: SearchableLocation?
    var startDate: Date?
    var endDate: Date?
    var imageUrl: String?
    var image: UIImage?
    var identifier: String?
    var organiser: String?
    var longDescription: String?
    var shortDescription: String? = nil
    var graphEvent: EventModel?
    
    convenience init(with dictionary:[String:Any]) {
        self.init(with: JSON(dictionary))
    }
    
    convenience init(with dictionary: JSON) {
        self.init()
        name = dictionary["name"].string
        place = dictionary["place"]["name"].string
        location = FacebookLocation.location(from: dictionary["place"])
        identifier = dictionary["id"].string
        imageUrl = dictionary["cover"]["source"].string
        organiser = dictionary["owner"]["name"].string
        if let time = dictionary["start_time"].string {
            startDate = DateFormatters.facebookDateTimeFormatter.date(from: time)
        }
        if let time = dictionary["end_time"].string {
            endDate = DateFormatters.facebookDateTimeFormatter.date(from: time)
        }
        longDescription = dictionary["description"].string
    }
    
    convenience init(with id: String) {
        self.init()
        self.identifier = id
    }
    
    class func create(with data: Any) ->[FacebookEventEntity] {
        let items = JSON(data)["data"]
        return items.map({ (_, body) -> FacebookEventEntity in
            return FacebookEventEntity(with: body)
        })
    }
    
    var hashValue: Int {
        guard let identifier = identifier, let hash = Int(identifier) else { return 0 }
        return hash
    }
    
}

func == (lhs: FacebookEventEntity, rhs: FacebookEventEntity) -> Bool {
    return lhs.identifier == rhs.identifier
}

