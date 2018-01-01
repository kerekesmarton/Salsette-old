//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

class FacebookEventEntity: SearchableEntity, Equatable, Hashable {
    var name: String?
    var place: String?
    var location: String?
    var startDate: Date?
    var endDate: Date?
    var imageUrl: String?
    var image: UIImage?
    var identifier: String?
    var organiser: String?
    var longDescription: String?
    var shortDescription: String? = nil
    
    convenience init(with dictionary:[String:Any]) {
        self.init(with: JSON(dictionary))
    }
    
    convenience init(with dictionary: JSON) {
        self.init()
        name = dictionary["name"].string
        place = dictionary["place"]["name"].string
        location = location(from: dictionary["place"]["location"])
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
    
    private func location(from json: JSON) -> String {
        var address = "\(json["zip"].string ?? "") \(json["city"].string ?? "") \(json["street"].string ?? "") \(json["country"].string ?? "")"
        
        if let lon = json["longitude"].string, let lat = json["latitude"].string {
            address.append("latitude:\(lat), longitude:\(lon)")
        }
        
        return address
    }
    
    var hashValue: Int {
        guard let identifier = identifier, let hash = Int(identifier) else { return 0 }
        return hash
    }
    
}

func == (lhs: FacebookEventEntity, rhs: FacebookEventEntity) -> Bool {
    return lhs.identifier == rhs.identifier
}

