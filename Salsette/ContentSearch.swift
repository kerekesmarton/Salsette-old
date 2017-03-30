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
        let first = (match(member: name, to: params.name) || match(member: organiser, to: params.name))
        let second = match(member: location, to: params.location)
        let third = matchDates(start: startDate, end: endDate, between: params.startDate, criteriaEnd: params.endDate)
        return first && second && third
//            match(member: type, to: params.type) &&
    }
    
    private func match(member: String, to criteria: String?) -> Bool {
        guard let exisitingCriteria = criteria, isValid(name: exisitingCriteria) else {
            return true // if there's no criteria, it should pass
        }
        return member.contains(exisitingCriteria)
    }
    
    private func matchDates(start: Date, end: Date, between criteriaStart: Date?, criteriaEnd: Date?) -> Bool {
        guard let existingCriteriaStart = criteriaStart,
            let existingCriteriaEnd = criteriaEnd else {
            return true
        }
        return startDate > existingCriteriaStart && endDate < existingCriteriaEnd
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
