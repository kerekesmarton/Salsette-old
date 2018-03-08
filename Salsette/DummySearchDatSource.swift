//
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct DummySearchDatSource {
    var dummyEvents: [FacebookEvent] {
        
        return [FacebookEvent(with: ["name": "Salsa4Us - Salsa a Ligetben - 2017 06 30",
                                           "place": [
                                            "name": "Liget Club",
                                            "location": [
                                                "city": "Budapest",
                                                "country": "Hungary",
                                                "latitude": 47.47575,
                                                "longitude": 19.10292,
                                                "street": "Népligeti út 2.",
                                                "zip": "1101"],
                                            "id": "115228065231639"],
                                           "start_time": "2017-06-30T22:00:00+0200",
                                           "end_time": "2017-07-01T03:00:00+0200",
                                           "cover": [
                                            "offset_x": 0,
                                            "offset_y": 50,
                                            "source": "https://scontent.xx.fbcdn.net/v/t31.0-8/s720x720/19441948_890158844456709_4709361165923381055_o.jpg?oh=f63f17a1bca9a45c59cd82c18d3baad0&oe=59CEC74A",
                                            "id": "890158844456709"],
                                           "owner": [
                                            "name": "Salsa4Us",
                                            "id": "244520985687168"],
                                           "id": "157134578163987"]),
                
                FacebookEvent(with: ["name": "Salsa Imperial",
                                           "place": [
                                            "name": "Imperial Riding School Renaissance Vienna Hotel",
                                            "location": [
                                                "city": "Vienna",
                                                "country": "Austria",
                                                "latitude": 48.19712,
                                                "longitude": 16.38697,
                                                "street": "Ungargasse 60",
                                                "zip": "1030" ],
                                            "id": "377645685641597" ],
                                           "start_time": "2017-09-30T20:30:00+0200",
                                           "end_time": "2017-10-01T02:00:00+0200",
                                           "cover": [
                                            "offset_x": 7,
                                            "offset_y": 0,
                                            "source": "https://scontent.xx.fbcdn.net/v/t31.0-8/s720x720/17632183_1903237106556359_6289526442783239051_o.jpg?oh=f3a085d04416ef23b84ad7a93031b516&oe=59D9A46F",
                                            "id": "1903237106556359"],
                                           "owner": [
                                            "name": "Mi Manera - Dance Studio & Shop",
                                            "id": "1492294424317298" ],
                                           "id": "1198442400218276"])
        ]
    }
}
