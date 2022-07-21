//
//  Account+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/5/22.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var cash: Double
    @NSManaged public var created: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var startingValue: Double
    @NSManaged public var transactions: NSSet?

}

extension Account {
    
    var wrappedName: String {
        name ?? "No Name"
    }
    
    var currentValue: Double {
        var total = cash
        if let theTransactionsSet = self.transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction] {
            for t in theTransactions {
                total += t.currentValue
            }
            
        }
        return total
    }
    
    var percentChange:String {
        if currentValue >= startingValue
        {
            let growth = (currentValue / startingValue - 1) * 100
            return String(format: "+%.1f", growth) + "%"
        }
        else
        {
            let growth = (1 - currentValue / startingValue) * 100
            return String(format: "-%.1f", growth) + "%"
        }
    }
    
//    func addSplitsAndDividendsToTransactions(chartData: ChartData, context: NSManagedObjectContext) {
//        // loop through all transactions, loop through each ChartDataSplit and add to transaction, if it is not already there...
//        for t in self.transactions?.allObjects as! [Transaction] {
//            if let events = chartData.events, let splits = events.splits {
//                for s in splits {
//                    if !t.splitsContain(split: s.value) && t.splitIsInValidTimeFrame(split: s.value) {
//                        // add newSplit to Transaction
//                        let newSplit = Split(context: context)
//                        newSplit.updateSplitValuesFromChartDataSplit(split: s.value, dateOfRecord: s.key)
//                        t.addToSplits(newSplit)
//                        if newSplit.appliedToHolding == false {
//                            t.applySplit(split: newSplit, context: context)
//                        }
//                        
//                        print("Added split: \(newSplit.splitRatio) on \(newSplit.wrappedDate) to \(t.stock?.wrappedSymbol)")
//                    }
//                }
//            }
//        }
//        try? context.save()
//    }
    
}


// MARK: Generated accessors for transactions
extension Account {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}


extension Account : Identifiable {

}
