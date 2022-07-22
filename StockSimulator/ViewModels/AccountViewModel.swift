//
//  AccountViewModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/9/22.
//

import Foundation
import SwiftUI
import CoreData
import Combine

enum TradeStatus {
    case buySuccess(title: String, message: String)
    case sellSuccess(title: String, message: String)
    case sellAllSuccess(title: String, message: String)
    case error(title: String, message: String)
}

final class AccountViewModel: ObservableObject {
    
    @Published var assets: [Asset] = []
    
//    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc // CoreData
    
//    var dataService: AccountDataService
    @Published var account: Account
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(account: Account)
    {
        self.account = account
//        self.dataService = AccountDataService(account: account)
        loadAssets()
        addSubscribers()
    }
    
    func addSubscribers() {
//        dataService.$holdings
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] returnHoldings in
//                self?.holdings = returnHoldings
//            }
//            .store(in: &cancellables)
    }
    
    func loadAssets()
    {
        var theAssets = [Asset]()
        if let theTransactionsSet = account.transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction]
        {
            for t in theTransactions {
                // see if I already have asset in the assets
                if let foundAsset = theAssets.first(where: {$0.stock.wrappedSymbol == t.stock?.wrappedSymbol}) {
                    foundAsset.transactions.append(t)
                }
                else {
                    // make a new asset and add it to theAssets
                    if let theStock = t.stock {
                        let newAsset = Asset(transactions: [t], stock: theStock)
                        theAssets.append(newAsset)
                    }
                }
            }
        }
        DispatchQueue.main.async{
            self.assets = theAssets
        }
    }
    
    
    func updateAssetValues()
    {
        for asset in assets {
//            asset.updateValue()
//            asset.updateValue()
            if !asset.isClosed {
                let apiCaller = APICaller.shared
                apiCaller.getQuoteData(searchSymbols: asset.stock.wrappedSymbol) {
                    connectionResult in

                    switch connectionResult {
                        case .success(let theStocks):
                            // link the stocks to the current stock prices, update the values,
                            for snapshot in theStocks
                            {
                                asset.stock.updateValuesFromStockSnapshot(snapshot: snapshot)
                                print("updated values for \(asset.stock.wrappedSymbol) to \(asset.stock.regularMarketPrice)")
                            }
        //                    try? self.dataController.container.viewContext.save()
                            if self.moc.hasChanges {
                                try? self.moc.save()
                            }
                            
                            self.loadAssets()
                        case .failure(let error):
        //                    errorMessage = error
                            print(error)
        //                    if account.assets.count > 0 {
        //                        showingErrorAlert = true
        //                    }
                        default:
                            print("connectionResult was not success or failure")
                    }
                }
            }
            
        }
    }
    
    func updateSplitsAndDividends(context: NSManagedObjectContext) {
        for asset in assets {
            if asset.isClosed == false {
                APICaller.shared.getChartDataWithSplitsAndDividends(searchSymbol: asset.stock.wrappedSymbol, range: "max") { connectionResult in
                    switch connectionResult {
                    case .success(let array):
                        print("We should never get this: \(array)")
                    case .chartSuccess(let chartData):
    //                    if asset.stock.symbol == "F" {
    //                        if let events = chartData.events, let dividends = events.dividends {
    //                            for d in dividends {
    //                                let dateDouble = Double(d.key) ?? 0.0
    //                                let dateOfRecord = Date(timeIntervalSince1970: dateDouble)
    //                                print("dateOfrecord: \(dateOfRecord.asShortDateString()) payDate: \(d.value.dateFormated)")
    //                            }
    //                        }
    //                    }

                        self.updateDividendsToTransactions(chartData: chartData, asset: asset, context: context)
                        self.updateSplitsToTransactions(chartData: chartData, asset: asset, context: context)
                    case .failure(let string):
                        print("Error loading dividends and splits for \(string)")
                    }
                }
            }
            
        }
    }
    
    func updateDividendsToTransactions(chartData: ChartData, asset: Asset, context: NSManagedObjectContext)
    {
        for t in asset.transactions {
            if let events = chartData.events, let thedividends = events.dividends {
//                print("found \(thedividends.count) dividends")
                for d in thedividends {
                    let price = chartData.priceAtOpenOnDate(date: d.value.date) ?? asset.stock.regularMarketPrice
                    t.addAndApplyDividendIfValid(dividend: d.value, dateOfRecord: d.key, stockPriceAtDividend: price, context: context)
                }
            }
        }
    }
    
    func updateSplitsToTransactions(chartData: ChartData, asset: Asset, context: NSManagedObjectContext)
    {
  
        for t in asset.transactions {
            if let events = chartData.events, let thesplits = events.splits {
//                    print("found \(thesplits.count) splits")
                for s in thesplits {
                    t.addAndApplySplitIfValid(split: s.value, dateOfRecord: s.key, context: context)
                }
            }
        }
    }
    
    
    func testSampleSplit(context: NSManagedObjectContext) {
        for asset in assets {
            for t in asset.transactions {
                let data = ChartMockData.sampleSplitNow
                if let events = data.events, let thesplits = events.splits {
                    for s in thesplits {
                        t.addAndApplySplitIfValid(split: s.value, dateOfRecord: s.key, context:context)
//                        print("Added Split \(testDividend.amount) to transaction \(t.numShares) shares of \(t.stock!.wrappedSymbol)")
                    }
                }
            }
        }
    }
    
    func testSampleDividend(context: NSManagedObjectContext) {
        for asset in assets {
            for t in asset.transactions {
                let data = ChartMockData.sampleDividendNow
                if let events = data.events, let thedividends = events.dividends {
                    for d in thedividends {
                        t.addAndApplyDividendIfValid(dividend: d.value, dateOfRecord: d.key, stockPriceAtDividend: asset.stock.regularMarketPrice, context: context)
//                        print("Added Dividend \(testDividend.amount) to transaction \(t.numShares) shares of \(t.stock!.wrappedSymbol)")
                    }
                }
            }
        }
    }
    
    func buyShares(numShares: Double, stockSnapshot: StockSnapshot, context: NSManagedObjectContext, completion: @escaping (TradeStatus) -> Void)
    {
        // check if you can afford the trade first...
        if canAffordTrade(numShares: numShares, stockSnapshot: stockSnapshot)
        {
            let newTransaction = Transaction(context: context)
            newTransaction.updateValuesFromBuy(account: self.account, purchasePrice: stockSnapshot.regularMarketPrice, numShares: numShares)
            
            let newStock = Stock(context: context)
            newStock.updateValuesFromStockSnapshot(snapshot: stockSnapshot)
            
            newTransaction.stock = newStock
                
            account.addToTransactions(newTransaction)
            // decrease cash amount in account by purchase price
            account.cash -= newTransaction.costBasis
            
            if context.hasChanges {
                try? context.save() // save to CoreData
                print("transaction and holding has been added to account")
                
            }
            completion(.buySuccess(title: "Success", message: "Successfully bought \(numShares) shares of \(stockSnapshot.symbol)"))

        }
        else {
            completion(.error(title: "Error", message: "You do not have enough cash to make the transaction"))
            
        }
    }
    
    func sellShares(numShares: Double, stockSnapshot: StockSnapshot, context: NSManagedObjectContext, completion: @escaping(TradeStatus) -> Void) {
        // see if you own the asset first
        if let theTransactionsSet = account.transactions, let transactions = Array(theTransactionsSet) as? [Transaction] {
            let filtered = transactions.filter({$0.stock?.symbol == stockSnapshot.symbol && $0.isClosed == false})
            
            // you own asset, so, start to sell
            if filtered.count > 0 {
                if let foundStock = transactions[0].stock {
                    let foundAsset = Asset(transactions: filtered, stock: foundStock)
                    
                    if numShares == foundAsset.totalShares { // sell everything and close all transactions
                        for t in filtered {
                            t.closeTransaction(sellPrice: stockSnapshot.regularMarketPrice)
                            
                            account.cash += t.totalProceeds
                            print("sold \(t.numShares) of \(foundStock.wrappedDisplayName)")
                        }
                        if context.hasChanges {
                            try? context.save()
                            print("Finished selling \(foundStock.wrappedSymbol): \(numShares) total shares sold. and saved to CoreData")
                        }
                        completion(.sellSuccess(title: "Success", message: "Successfully sold \(numShares) shares of \(stockSnapshot.symbol)"))
                        
                    }
                    else if numShares < foundAsset.totalShares { // we can sell the shares.
                        // figure out how to sell asset. Use FILO. Right now just selling in any order
                        var numSold = 0.0
        
                        for t in filtered.sorted(by: {$0.wrappedBuyDate > $1.wrappedBuyDate}) {
                            if numSold + t.numShares <= numShares {
                                // close this transaction. we can sell it all
                                t.closeTransaction(sellPrice: foundStock.regularMarketPrice)
                                numSold += t.numShares
                                account.cash += t.totalProceeds
                                print("sold \(t.numShares) of \(foundStock.wrappedDisplayName)")
                                if numSold == numShares
                                {
                                    break // need to break loop so that it doesnt finish the loop with filtered
                                }
                                
                            }
                            else if numSold + t.numShares > numShares {
                                // split transaction into 2. 1 that has the number of shares we are trying to sell and 1 thats a new one with the remaining shares that arent sold. delete the original transaction
                                let newTransactionOpen = Transaction(context: context)
                                newTransactionOpen.copyTransaction(from: t)
                                
                                let newTranactionClose = Transaction(context: context)
                                newTranactionClose.copyTransaction(from: t)
                                
                                newTranactionClose.numShares = numShares - numSold
                                
                                newTranactionClose.closeTransaction(sellPrice: stockSnapshot.regularMarketPrice)
                                
                                newTransactionOpen.numShares -= newTranactionClose.numShares
                                newTransactionOpen.costBasis = newTransactionOpen.numShares * newTransactionOpen.purchasePrice

                                account.addToTransactions(newTranactionClose)
                                account.addToTransactions(newTransactionOpen)
                                
                                account.removeFromTransactions(t)
                                
                                numSold = numShares // we just sold them all
                                account.cash += newTranactionClose.totalProceeds
                                print("sold \(newTranactionClose.numShares) of \(foundStock.wrappedDisplayName)")
                                break // break the loop, because we sold the amount specified
                            }
                        }
                        if context.hasChanges {
                            try? context.save()
                            print("Finished selling \(foundStock.wrappedSymbol): \(numShares) total shares sold. and saved to CoreData")
                        }
                        completion(.sellSuccess(title: "Success", message: "Successfully sold \(numShares) shares of \(stockSnapshot.symbol)"))
                    }
                    else {
                        // numSharesNum > than the number of shares that you own
                        completion(.error(title: "Error", message: "Cannot sell: You do not own \(numShares) shares of \(stockSnapshot.symbol)"))
                    }
                }
                else {
                    completion(.error(title: "Error", message: "Cannot sell: You do not own \(numShares) shares of \(stockSnapshot.symbol)"))
                }
                
            }
            else {
                completion(.error(title: "Error", message: "Cannot sell: You do not own \(numShares) shares of \(stockSnapshot.symbol)"))
            }
        }
        else {
            completion(.error(title: "Error", message: "Cannot sell: You do not own \(numShares) shares of \(stockSnapshot.symbol)"))
        }
    }
    
    func canAffordTrade(numShares: Double, stockSnapshot: StockSnapshot) -> Bool
    {
        return account.cash > stockSnapshot.regularMarketPrice * numShares
    }
    
    func sellAllShares(stockSnapshot: StockSnapshot, context: NSManagedObjectContext, completion: @escaping(TradeStatus) -> Void)
    {
        if let theTransactionsSet = account.transactions, let transactions = Array(theTransactionsSet) as? [Transaction] {
            // filter transactions that are open and have the same symbol.
            let filtered = transactions.filter({$0.stock?.symbol == stockSnapshot.symbol && $0.isClosed == false})
            
            var sharesSold = 0.0
            for t in filtered {
                t.closeTransaction(sellPrice: stockSnapshot.regularMarketPrice)
                account.cash += t.totalProceeds
                sharesSold += t.numShares
                print("sold \(t.numShares) of \(stockSnapshot.symbol)")
            }
            completion(.sellAllSuccess(title: "Success", message: "Sold all shares (\(sharesSold.asDecimalWith6Decimals())) of \(stockSnapshot.symbol)"))
        }
        else {
            completion(.error(title: "Error", message: "Failed to sell shares of \(stockSnapshot.symbol)"))
        }
    }
    

}
