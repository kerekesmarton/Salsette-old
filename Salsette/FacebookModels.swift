//  Copyright © 2018 Marton Kerekes. All rights reserved.

import Foundation

struct FacebookResponse: Codable {
    var data: [FacebookEventModel]
}

struct FacebookEventModel: Codable {
    var name: String?
    var location: FacebookLocationModel?
    var startDate: Date?
    var endDate: Date?
    var imageUrl: URL?
    var identifier: String?
    var organiser: String?
    var longDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case location = "place"
        case imageUrl = "cover"
        case organiser = "owner"
        case longDescription = "description"
        case startDate = "start_time"
        case endDate = "end_time"
        case name
    }
    
    struct Cover: Codable {
        var source: URL?
    }
    
    struct Owner: Codable {
        var name: String?
    }
    
    fileprivate func decodeEndDate(_ container: KeyedDecodingContainer<FacebookEventModel.CodingKeys>) throws -> Date {
        let endDateString = try container.decode(String.self, forKey: .startDate)
        if let date = DateFormatters.facebookDateTimeFormatter.date(from: endDateString) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .startDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
    }
    
    fileprivate func decodeStartDate(_ container: KeyedDecodingContainer<FacebookEventModel.CodingKeys>) throws -> Date {
        let startDateString = try container.decode(String.self, forKey: .startDate)
        if let date = DateFormatters.facebookDateTimeFormatter.date(from: startDateString) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .startDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
    }
    
    fileprivate func decodeOrganiser(_ container: KeyedDecodingContainer<FacebookEventModel.CodingKeys>) throws -> String? {
        let owner = try container.decode(Owner.self, forKey: .organiser)
        return owner.name
    }
    
    fileprivate func decodeImageUrl(_ container: KeyedDecodingContainer<FacebookEventModel.CodingKeys>) throws -> URL? {
        let cover = try container.decode(Cover.self, forKey: .imageUrl)
        return cover.source
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(FacebookLocationModel.self, forKey: .location)
        identifier = try container.decode(String.self, forKey: .identifier)
        startDate = try decodeStartDate(container)
        endDate = try decodeEndDate(container)
        imageUrl = try decodeImageUrl(container)
        organiser = try decodeOrganiser(container)
    }

    static func extractFacebookEvent(from response: Any) throws -> [FacebookEvent] {
        guard let response = response as? [String:Any], let unwrappedData = response["data"] else { return [] }
        let data = try JSONSerialization.data(withJSONObject: unwrappedData, options: .prettyPrinted)
        let eventModels = try JSONDecoder().decode([FacebookEventModel].self, from: data)
        
        
        let event = FacebookEvent()
        
        return [event]
    }

    
}

struct FacebookLocationModel: Codable {
    var city: String?
    var country: String?
    var address: String?
    var name: String?
    var zip: String?
    
    static func location(from json: JSON) -> FacebookLocation {
        let location = FacebookLocation()
        location.name = json["name"].string
        location.zip = json["location"]["zip"].string
        location.city = json["location"]["city"].string
        location.address = json["location"]["street"].string
        location.country = json["location"]["country"].string
        
        return location
    }
}
