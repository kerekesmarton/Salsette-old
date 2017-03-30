//
//  ContentData.swift
//  Salsette
//
//  Created by Marton Kerekes on 29/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit



public protocol ContentEntityInterface {
    var image: UIImage? { get }
    var organiser: String { get }
    var name: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var location: String { get }
    var type: EventTypes { get }
}

public extension ContentEntityInterface {
    
    public func matches() -> Bool {
        let params = GlobalSearch.sharedInstance.searchParameters
        let nameAndOrg = (match(member: name, to: params.name) || match(member: organiser, to: params.name))
        let loc = match(member: location, to: params.location)
        let date = matchDates(start: startDate, end: endDate, between: params.startDate, criteriaEnd: params.endDate)
//        let type = matchType(member: type, to: params.type)
        return nameAndOrg && loc && date
    }
    
    private func match(member: String, to criteria: String?) -> Bool {
        guard let exisitingCriteria = criteria, isValid(name: exisitingCriteria) else {
            return true // if there's no criteria, it should pass
        }
        return member.contains(exisitingCriteria)
    }
    
//    private func matchType(member: EventTypes, to criteria: String?) -> Bool {
//        guard let exisitingCriteria = criteria, isValid(name: exisitingCriteria) else {
//            return true // if there's no criteria, it should pass
//        }
//        return member.contains(exisitingCriteria)
//    }
    
    private func matching(member: String, to criteria: String?) -> ContentEntityInterface? {
        guard let exisitingCriteria = criteria, isValid(name: exisitingCriteria) else {
            return self // if there's no criteria, it should pass
        }
        return member.contains(exisitingCriteria) ? self : nil
    }
    
    private func matchDates(start: Date, end: Date, between criteriaStart: Date?, criteriaEnd: Date?) -> Bool {
        guard let existingCriteriaStart = criteriaStart,
            let existingCriteriaEnd = criteriaEnd else {
            return true
        }
        return startDate > existingCriteriaStart && endDate < existingCriteriaEnd
    }
    
    private func matchingDates(start: Date, end: Date, between criteriaStart: Date?, criteriaEnd: Date?) -> ContentEntityInterface? {
        guard let existingCriteriaStart = criteriaStart,
            let existingCriteriaEnd = criteriaEnd else {
                return self
        }
        return startDate > existingCriteriaStart && endDate < existingCriteriaEnd ? self: nil
    }
    
    func isValid(name: String) -> Bool {
        if name.characters.count == 0 {
            return false
        }
        
        let range = name.rangeOfCharacter(from: .whitespacesAndNewlines)
        if let range = range, range.lowerBound != range.upperBound {
            return false
        }
        
        return true
    }
}
