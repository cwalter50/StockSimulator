//
//  Dividend+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/18/22.
//
//

import Foundation
import CoreData


extension Dividend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dividend> {
        return NSFetchRequest<Dividend>(entityName: "Dividend")
    }

    @NSManaged public var amount: Double
    @NSManaged public var appliedToHolding: Bool
    @NSManaged public var date: Int32
    @NSManaged public var dateOfRecord: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var stockPriceAtDate: Double
    @NSManaged public var transaction: Transaction?
    
    var wrappedDate: Date {
        return Date(timeIntervalSince1970: Double(date))
    }
    
    func updateDividendValuesFromChartDataDividend(dividend: ChartData.Dividend, dateOfRecord: String, stockPriceAtDate: Double) {

        self.amount = dividend.amount
        self.appliedToHolding = false
        self.date = Int32(dividend.date)
        self.dateOfRecord = Int32(dateOfRecord) ?? Int32(dividend.date)
        self.id = UUID()
        self.stockPriceAtDate = stockPriceAtDate
    }

}

extension Dividend : Identifiable {

}
