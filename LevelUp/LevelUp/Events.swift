//
//  Events.swift
//  LevelUp
//
//  Created by Joshua Escribano on 12/6/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import Foundation
import EventKit

// Static class handling calendar events
class Events: NSObject {
    static let calendarId = "LevelUp"
    static private var _calendar: EKCalendar? = nil
    static var calendar: EKCalendar {
        get {
            if _calendar == nil {
                let eventStore = EKEventStore()
                let possibleCalendar = eventStore.calendar(withIdentifier: calendarId)
                if possibleCalendar != nil {
                    return possibleCalendar!
                } else {
                    _calendar = EKCalendar(for: .event, eventStore: eventStore)
                    _calendar?.title = calendarId
                    
                    let sourcesInEventStore = eventStore.sources
                    _calendar?.source = sourcesInEventStore.filter{
                        (source: EKSource) -> Bool in
                        source.sourceType.rawValue == EKSourceType.local.rawValue
                        }.first!
                    
                    try? eventStore.saveCalendar(_calendar!, commit: true)
                    return _calendar!
                }
            }
            
            return _calendar!
        }
    }
    class func requestAccess() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: {_,_ in})
    }
    class func save(title: String, date: Date) {

        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.calendar = calendar
        event.title = title
        event.startDate = date
        
        let cal = Calendar.current
        let endDate = cal.date(byAdding: .minute, value: 30, to: date)
        event.endDate = endDate!
        
        try? eventStore.save(event, span: .thisEvent)
    }
}
