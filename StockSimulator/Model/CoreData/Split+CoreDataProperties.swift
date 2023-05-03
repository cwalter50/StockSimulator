//
//  Split+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/18/22.
//
//

import Foundation
import CoreData


extension Split {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Split> {
        return NSFetchRequest<Split>(entityName: "Split")
    }

    @NSManaged public var appliedToHolding: Bool
    @NSManaged public var date: Int32
    @NSManaged public var dateOfRecord: Int32
    @NSManaged public var denominator: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var numerator: Int32
    @NSManaged public var splitRatio: String?
    @NSManaged public var transaction: Transaction?
    
    var wrappedDate: Date {
        return Date(timeIntervalSince1970: Double(date))
    }
    
    func updateSplitValuesFromChartDataSplit(split: ChartData.Split, dateOfRecord: String) {
        self.date = Int32(split.date)
        self.numerator = Int32(split.numerator)
        self.denominator = Int32(split.denominator)
        self.splitRatio = split.splitRatio
        self.dateOfRecord = Int32(dateOfRecord) ?? Int32(split.date)
        self.id = UUID()
        self.appliedToHolding = false
    }
    
}

extension Split : Identifiable {

}
