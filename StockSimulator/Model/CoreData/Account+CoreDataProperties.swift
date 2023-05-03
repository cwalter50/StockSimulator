//
//  Account+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/18/23.
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
    @NSManaged public var notes: String?
    @NSManaged public var startingValue: Double
    @NSManaged public var transactions: NSSet?
    @NSManaged public var dividends: NSSet?

}

extension Account {
    
    var wrappedName: String {
        name ?? "No Name"
    }
    
    var wrappedNotes: String {
        notes ?? "Add Notes..."
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

// MARK: Generated accessors for dividends
extension Account {

    @objc(addDividendsObject:)
    @NSManaged public func addToDividends(_ value: Dividend)

    @objc(removeDividendsObject:)
    @NSManaged public func removeFromDividends(_ value: Dividend)

    @objc(addDividends:)
    @NSManaged public func addToDividends(_ values: NSSet)

    @objc(removeDividends:)
    @NSManaged public func removeFromDividends(_ values: NSSet)

}

extension Account : Identifiable {

}

// MARK: Dividends and Splits methods
extension Account {

    
    // This is the main function that will check if the dividend is valid, then apply it to the account if it is.
    func addAndApplyDividendIfValid(dividend: ChartData.Dividend, dateOfRecord: String, stockPriceAtDividend: Double, stock: Stock, context: NSManagedObjectContext)
    {
        if isDividendValid(dividend: dividend, stockSymbol: stock.wrappedSymbol)
        {
            // create a new transaction from Dividend
            let totalShares = numberOfSharesOwnedAtDate(date: Double(dividend.date), stockSymbol: stock.wrappedSymbol)
            if totalShares > 0.0 {
                let newDividend = Dividend(context: context)
                newDividend.updateDividendValuesFromChartDataDividend(dividend: dividend, dateOfRecord: dateOfRecord, stockPriceAtDate: stockPriceAtDividend, stockSymbol: stock.wrappedSymbol, account: self)
                
                let newShares = dividend.amount * totalShares / stockPriceAtDividend
                
                let newTransaction = Transaction(context: context)
                newTransaction.updateValuesFromBuy(account: self, purchasePrice: stockPriceAtDividend, numShares: newShares, buyDate: Date(timeIntervalSince1970: Double(dividend.date)))
                newTransaction.eventType = "DIVIDEND"
                newTransaction.stock = stock
                addToTransactions(newTransaction)
                addToDividends(newDividend)
                newDividend.appliedToHolding = true
                if context.hasChanges {
                    try? context.save() // this should save the dividend to the account, so that if we get another 
                }
            }
        }
    }
    
    // this return true if dividend is not in the Account already. It will return false if Dividend is in account is already applied.
    private func isDividendValid(dividend: ChartData.Dividend, stockSymbol: String) -> Bool
    {
        if let theDividendsSet = self.dividends, let theDividends = Array(theDividendsSet) as? [Dividend] {
            return !theDividends.contains(where: {$0.date == dividend.date && $0.stockSymbol == stockSymbol})
        }
        return true
    }
    
    // this will be used to help determine how many shares we own to apply the dividend to.
    private func numberOfSharesOwnedAtDate(date: Double, stockSymbol: String) -> Double
    {
        var total = 0.0
        if let theTransactionSet = self.transactions, let theTransactions = Array(theTransactionSet) as? [Transaction] {
            for t in theTransactions {
                if t.stock?.wrappedSymbol == stockSymbol && transactionIsInValidTimeInterval(dividendDate: date, transaction: t) {
                    total += t.numShares
                }
            }
        }
        return total
    }
    
    // Helper method to determine if transaction is in the correct time Interval to get the dividend.
    private func transactionIsInValidTimeInterval(dividendDate: Double, transaction: Transaction) -> Bool {
        
        if transaction.wrappedBuyDate.timeIntervalSince1970 < dividendDate && transaction.isClosed == false {
            return true
        }
        if let sellDate = transaction.sellDate {
            if transaction.wrappedBuyDate.timeIntervalSince1970 < dividendDate && sellDate.timeIntervalSince1970 >= dividendDate {
                return true
            }
        }
        if transaction.wrappedBuyDate.timeIntervalSince1970 < dividendDate && transaction.sellDate == nil {
            return true
        }
        
        return false
    }
}
