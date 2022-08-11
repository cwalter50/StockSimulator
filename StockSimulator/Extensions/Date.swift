//
//  Date.swift
//  StockSimulator
//
//  Created by Christopher Walter on 5/18/22.
//

import Foundation


extension Date
{
    
    // convert a time since 1970 into a date to be displayed
//    init()
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    private var shortDateAndTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
    
    func asShortDateAndTimeString() -> String {
        return shortDateAndTimeFormatter.string(from: self)
    }
    
    private var mediumFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    func asMediumDateString() -> String {
        return mediumFormatter.string(from: self)
    }
    
}
