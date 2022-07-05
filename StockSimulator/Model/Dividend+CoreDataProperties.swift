//
//  Dividend+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/5/22.
//
//

import Foundation
import CoreData


extension Dividend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dividend> {
        return NSFetchRequest<Dividend>(entityName: "Dividend")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var amount: Double
    @NSManaged public var sppliedToHolding: Bool
    @NSManaged public var holding: Holding?

}

extension Dividend : Identifiable {

}
