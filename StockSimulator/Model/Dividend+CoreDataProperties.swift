//
//  Dividend+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/18/23.
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
    @NSManaged public var stockSymbol: String?
    @NSManaged public var transaction: Transaction?
    @NSManaged public var account: Account?
    
    var wrappedDate: Date {
        return Date(timeIntervalSince1970: Double(date))
    }
    
    func updateDividendValuesFromChartDataDividend(dividend: ChartData.Dividend, dateOfRecord: String, stockPriceAtDate: Double, stockSymbol: String, account: Account) {

        self.amount = dividend.amount
        self.appliedToHolding = false
        self.date = Int32(dividend.date)
        self.dateOfRecord = Int32(dateOfRecord) ?? Int32(dividend.date)
        self.id = UUID()
        self.stockPriceAtDate = stockPriceAtDate
        self.stockSymbol = stockSymbol
        self.account = account
    }

}

extension Dividend : Identifiable {

}
