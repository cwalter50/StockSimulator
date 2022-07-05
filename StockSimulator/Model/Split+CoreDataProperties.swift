//
//  Split+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/5/22.
//
//

import Foundation
import CoreData


extension Split {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Split> {
        return NSFetchRequest<Split>(entityName: "Split")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var numerator: Int16
    @NSManaged public var denominator: Int16
    @NSManaged public var date: Date?
    @NSManaged public var splitRatio: String?
    @NSManaged public var appliedToHolding: Bool
    @NSManaged public var holding: Holding?

}

extension Split : Identifiable {

}
