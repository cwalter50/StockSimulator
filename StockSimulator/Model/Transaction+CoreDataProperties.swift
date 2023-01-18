//
//  Transaction+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/18/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var buyDate: Date?
    @NSManaged public var costBasis: Double
    @NSManaged public var id: UUID?
    @NSManaged public var isClosed: Bool
    @NSManaged public var numShares: Double
    @NSManaged public var purchasePrice: Double
    @NSManaged public var sellDate: Date?
    @NSManaged public var sellPrice: Double
    @NSManaged public var totalProceeds: Double
    @NSManaged public var eventType: String? // This will be used to determine, if we have a dividend payment, splits, etc. // might not need because each transaction has a buy and a sell. Also when you apply a dividend, you are applying
    @NSManaged public var account: Account?
    @NSManaged public var stock: Stock?
    @NSManaged public var dividends: NSSet?
    @NSManaged public var splits: NSSet?
    
    //    // Cost basis is when we buy
    //    var costBasis: Double {
    //        return numShares * purchasePrice
    //    }
    //
    //    // total proceeds are when we sell
    //    var totalProceeds: Double {
    //        return numShares * sellPrice
    //    }
    
    // might not need eventtype.
    var wrappedEventType: String {
        return eventType ?? "UnKnown"
    }
    
//    var toString: String {
//        var result = "\(wrappedEventType): \(numShares) of \(stock?.wrappedSymbol ?? "UnKnown") at price $\(purchasePrice) on date \(buyDate?.asShortDateString() ?? Date().asShortDateString())"
//        
//        if let sellDate = sellDate {
//            result += "\nSold on date \(sellDate) at price $\(sellPrice)"
//        }
//        return result
//    }
    
    var wrappedBuyDate: Date {
        return self.buyDate ?? Date()
    }
    
        
    var currentValue: Double {
        if isClosed == false {
            if let theStock = stock {
                return theStock.regularMarketPrice * numShares
            }
        }
        return 0.0
    }
        
    func closeTransaction(sellPrice: Double)
    {
        self.sellDate = Date()
        self.isClosed = true
        self.sellPrice = sellPrice
        self.totalProceeds = self.numShares * sellPrice
        self.eventType = "\(wrappedEventType)/SELL"
    }
    
    func copyTransaction(from transaction: Transaction)
    {
        // do not copy UUID... Each transaction should be unique...
        self.purchasePrice = transaction.purchasePrice
        self.buyDate = transaction.buyDate
        self.numShares = transaction.numShares
        self.isClosed = transaction.isClosed
        self.sellDate = transaction.sellDate
        self.sellPrice = transaction.sellPrice
        self.stock = transaction.stock
        self.account = transaction.account
        self.eventType = transaction.eventType
        self.splits = transaction.splits
        self.dividends = transaction.dividends
        self.costBasis = transaction.costBasis
        self.totalProceeds = transaction.totalProceeds
    }
    
    func updateValuesFromBuy(account: Account, purchasePrice:Double, numShares: Double, buyDate: Date)
    {
        self.account = account
        self.id = UUID()
        self.buyDate = buyDate
        self.purchasePrice = purchasePrice
        self.numShares = numShares
        self.isClosed = false
        self.costBasis = purchasePrice * numShares
        self.eventType = "BUY"
//        self.totalProceeds = 0 // this should happen by default
    }

}

// MARK: Generated accessors for dividends
extension Transaction {

    @objc(addDividendsObject:)
    @NSManaged public func addToDividends(_ value: Dividend)

    @objc(removeDividendsObject:)
    @NSManaged public func removeFromDividends(_ value: Dividend)

    @objc(addDividends:)
    @NSManaged public func addToDividends(_ values: NSSet)

    @objc(removeDividends:)
    @NSManaged public func removeFromDividends(_ values: NSSet)

}

// MARK: Generated accessors for splits
extension Transaction {

    @objc(addSplitsObject:)
    @NSManaged public func addToSplits(_ value: Split)

    @objc(removeSplitsObject:)
    @NSManaged public func removeFromSplits(_ value: Split)

    @objc(addSplits:)
    @NSManaged public func addToSplits(_ values: NSSet)

    @objc(removeSplits:)
    @NSManaged public func removeFromSplits(_ values: NSSet)

}

extension Transaction : Identifiable {

}

// MARK: Dividends and Splits methods
extension Transaction {
    // MARK: This will check if Dividend from ChartData is valid before adding it to the transaction's list of dividends and applying it. Be careful of making sure that the Dividend time frame is after the buy date and != to. This could cause recursion, because if you pay a dividend on a date and you check for = to then you will apply the dividend over and over again to the dividend's transaction.
    func addAndApplyDividendIfValid(dividend: ChartData.Dividend, dateOfRecord: String, stockPriceAtDividend: Double?, context: NSManagedObjectContext)
    {
        if isDividendValid(dividend: dividend, dateOfRecord: dateOfRecord) {
            print("Found a valid dividend for \(self.stock?.symbol ?? "No Name"): ")
            print(dividend)
            print("Date of Record: \(dateOfRecord)")
            // make a new Dividend Object
            let d = Dividend(context: context)
            let price = stockPriceAtDividend ?? (stock?.regularMarketPrice ?? purchasePrice)
            d.updateDividendValuesFromChartDataDividend(dividend: dividend, dateOfRecord: dateOfRecord, stockPriceAtDate: price)
            self.addToDividends(d)
            
            // this will create a newTransaction
            self.applyDividend(dividend: d, chartDividend: dividend, context: context)
        }
        else {
//            print("Dividend \(dividend) is not valid to add to transaction." )
        }
    }
    
    // MARK: This will apply a dividend to the transaction and make a new transaction of the dividend
    private func applyDividend(dividend: Dividend, chartDividend: ChartData.Dividend, context: NSManagedObjectContext)
    {
        if dividend.appliedToHolding == false{
            dividend.appliedToHolding = true
            
            // make a new transaction and purchase the number of shares you can buy for the dividend...
            let newCash = dividend.amount * self.numShares
            let newShares = newCash / dividend.stockPriceAtDate
            if let account = account {
                let newTransaction = Transaction(context: context)
                newTransaction.updateValuesFromBuy(account: account, purchasePrice: dividend.stockPriceAtDate, numShares: newShares, buyDate: Date(timeIntervalSince1970: Double(chartDividend.date)))
                newTransaction.eventType = "DIVIDEND"
//                newTransaction.buyDate = Date(timeIntervalSince1970: Double(chartDividend.date))
                // add this dividend to the newTransaction's Dividends, so that it will not make duplicates
                newTransaction.addToDividends(dividend)
                newTransaction.stock = self.stock
                account.addToTransactions(newTransaction)
//                print("Dividend paid added transaction to \(newTransaction.stock?.symbol) \(newTransaction)")
//                print(chartDividend)
//                print(chartDividend.dateFormated)
            }
            else {
                print("Cannot find account to add dividend to the transaction")
            }
            // save the changed data
            if context.hasChanges {
                try? context.save()
            }
        }
        else {
            print("Cannot apply Dividend to Transaction")
        }
        
    }
    
    
    // MARK:  check if dividend is valid to be applied to Transaction. It is valid if the dividend has not already been added to the transaction, and the dividend record date is within the time frame of the buy date and sell date
    private func isDividendValid(dividend: ChartData.Dividend, dateOfRecord: String) -> Bool
    {
            return isDividendInValidTimeFrame(dividend: dividend) && !isDividendAlreadyAddedToTransaction(dividend: dividend)
        
    }
    // MARK: Checks if the dividend date is within the transactions window of holding the asset.
    private func isDividendInValidTimeFrame(dividend: ChartData.Dividend) -> Bool {
//        let dividendDate = Date(timeIntervalSince1970: Double(dateOfRecord) ?? Double(dividend.date))
        let dividendDate = Date(timeIntervalSince1970: Double(dividend.date))
        if let theSellDate = sellDate {
            return dividendDate > wrappedBuyDate && dividendDate < theSellDate
        }
        else { // this means that the transaction hasn't closed yet
              return dividendDate > wrappedBuyDate
        }
    }
    // MARK: Checks if the dividends already in the transactions contains the ChartData.dividend and if the transaction
    private func isDividendAlreadyAddedToTransaction(dividend: ChartData.Dividend) -> Bool
    {
        let theDividends = dividends?.allObjects as! [Dividend]
        print("Found \(theDividends.count) dividends for \(self.stock?.wrappedSymbol ?? "noName")")
        for d in theDividends
        {
            print("Dividend Date of record: \(d.date), dividend date: \(dividend.date)")
        }
        return theDividends.contains {$0.date == dividend.date} // dates are stored as Int32's
    }
    
    
    // MARK:  check if split is valid to be applied to Transaction. It is valid if the split has not already been added to the transaction, and the split record date is within the time frame of the buy date and sell date
    private func isSplitValid(split: ChartData.Split, dateOfRecord: String) -> Bool
    {
        return isSplitInValidTimeFrame(split: split) && !isSplitAlreadyAddedToTransaction(split: split)
    }
    
    // MARK: Checks if the splits already the transactions contains the ChartData.split
    func isSplitAlreadyAddedToTransaction(split: ChartData.Split) -> Bool
    {
        let theSplits = splits?.allObjects as! [Split]
        return theSplits.contains {$0.date == split.date}
    }
    // MARK: Checks if the split date is within the transactions window of holding the asset.
    func isSplitInValidTimeFrame(split: ChartData.Split) -> Bool
    {
        let splitDate = Date(timeIntervalSince1970: Double(split.date))
        if let theSellDate = sellDate {
            return splitDate > wrappedBuyDate && splitDate < theSellDate
        }
        else { // this means that the transaction hasn't closed yet
              return splitDate > wrappedBuyDate
        }
    }
    // MARK: This will check if Split from ChartData is valid before adding it to the transaction's list of splits and applying it.
    func addAndApplySplitIfValid(split: ChartData.Split, dateOfRecord: String, context: NSManagedObjectContext)
    {
        if isSplitValid(split: split, dateOfRecord: dateOfRecord) {
            // make a new Split Object and add it to transaction
            let s = Split(context: context)
            s.updateSplitValuesFromChartDataSplit(split: split, dateOfRecord: dateOfRecord)
            s.transaction = self
            self.addToSplits(s) // this and previous line may be redundant
            
            // change values on transaction
            if s.appliedToHolding == false {
                let splitRatio = Double(split.numerator) / Double(split.denominator)
                self.numShares *= splitRatio
                self.purchasePrice /= splitRatio
                s.appliedToHolding = true
            }
            if context.hasChanges {
                try? context.save()
            }
        }
        else {
//            print("Split is not valid to be added to transaction")
        }
    }
}
