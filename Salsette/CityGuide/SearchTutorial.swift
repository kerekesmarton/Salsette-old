//
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct AppTutorial: ContentEntityInterface {
    
    var name: String?
    var image: UIImage?
    var shortDescription: String?
    var longDescription: String?
    var organiser: String? { get { return nil }}
    var startDate: Date? { get { return nil }}
    var endDate: Date? { get { return nil }}
    var place: String? { get { return nil }}
    var location: String? { get { return nil }}
    var imageUrl: String? { get { return nil }}
    var identifier: String? { get { return nil }}
    var type: Dance? { get { return nil }}
    
    static var cards: [ContentEntityInterface] {
        get {
            didShow = true
            return [
                AppTutorial(name: "Welcome to Salsette.",
                             image: nil,
                             shortDescription: "Tap me!",
                             longDescription: "Thank you for installing. Here you can have a look at dance events you searched for."),
                AppTutorial(name: "Take your time, look around.",
                             image: nil,
                             shortDescription: "Your guide to the next dance class or party.",
                             longDescription: "Try changing some of the wording above.. search for the type of dance, name, location or dates."),
                AppTutorial(name: "Share it.",
                             image: nil,
                             shortDescription: "Log in and share your own events.",
                             longDescription: "By logging in with your facebook account, you can import and customize your dance events. What is the schedule? Which workshops will you offer?")
            ]
        }
    }
    
    static var didShow: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "didShowAppTutorial")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "didShowAppTutorial")
        }
    }
}
