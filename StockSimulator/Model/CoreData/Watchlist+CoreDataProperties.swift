//
//  Watchlist+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/4/22.
//
//

import Foundation
import CoreData


extension Watchlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Watchlist> {
        return NSFetchRequest<Watchlist>(entityName: "Watchlist")
    }
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var created: Date?
    @NSManaged public var stocks: NSSet?
    
    var wrappedName: String {
        name ?? "No Name"
    }

}

// MARK: Generated accessors for stocks
extension Watchlist {

    @objc(addStocksObject:)
    @NSManaged public func addToStocks(_ value: Stock)

    @objc(removeStocksObject:)
    @NSManaged public func removeFromStocks(_ value: Stock)

    @objc(addStocks:)
    @NSManaged public func addToStocks(_ values: NSSet)

    @objc(removeStocks:)
    @NSManaged public func removeFromStocks(_ values: NSSet)

}

extension Watchlist : Identifiable {

}
