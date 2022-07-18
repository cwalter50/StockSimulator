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

}

extension Dividend : Identifiable {

}
