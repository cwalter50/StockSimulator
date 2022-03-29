//
//  Extensions.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/24/22.
//

import Foundation
import SwiftUI


// This is used to normalize the data in an array so that we can plot it on the graph. Data is all over the place and change the values to all be between 0 and 1. 0 in min, 1 is max. might have to change this to 0.1 and 0.9 in the future, so that we have some white space at the top and bottom of the chart
extension Array where Element == Double {
    // Return the elements of the sequence Normalized
    var normalized: [Double] {
        if let min = self.min(), let max = self.max() {
            return self.map { ($0 - min) / ( max - min) }
        }
        else {
            // we do not have a minimum and maximum
            return []
        }
    }
    

    
}

extension Double {
    func autoFormat() -> Double
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return Double(truncating: formatter.number(from: "\(self)") ?? 0)
    }
}

extension Double {
    var priceFormatted:String{
        let strValue = String(format: "%.2f", self)
//        let strValue = "\(self)"
        let subStrings = strValue.split(separator: ".")
        let money = subStrings[0]
        var cents = "00"
        if subStrings.count > 1{
            cents = String(subStrings[1])

            if(cents.count == 1){
                cents = "0\(cents)"
            }
        }

        return "$\(money).\(cents)"
    }
}
