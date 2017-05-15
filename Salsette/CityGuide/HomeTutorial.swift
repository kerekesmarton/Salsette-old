// The MIT License (MIT)
//
// Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

struct HomeTutorial: ContentEntityInterface {
    var name: String?
    var image: UIImage?
    var shortDescription: String
    var description: String    
    
    var organiser: String? { get { return nil }}
    var startDate: Date? { get { return nil }}
    var endDate: Date? { get { return nil }}
    var location: String? { get { return nil }}
    var type: EventTypes? { get { return nil }}
    
    static var cards = [
        HomeTutorial(name: "Welcome to Salsette.",
                     image: #imageLiteral(resourceName: "vancouver"),
                     shortDescription: "Tap me!",
                     description: "Thank you for installing. Here you can have a look at dance events you searched for."),
        HomeTutorial(name: "Take your time, look around.",
                     image: #imageLiteral(resourceName: "toronto"),
                     shortDescription: "Your guide to the next dance class or party.",
                     description: "Try changing some of the wording above.. search for the type of dance, name, location or dates."),
        HomeTutorial(name: "Share it.",
                     image: #imageLiteral(resourceName: "montreal"),
                     shortDescription: "Log in and share your own events.",
                     description: "By logging in with your facebook account, you can import and customize your dance events. What is the schedule? Which workshops will you offer?")
    ]
    
    static var didShow: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "didShowHomeTutorial")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "didShowHomeTutorial")
        }
    }
}