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
    
    func updateSplitsAndDividends(context: NSManagedObjectContext) {
        for asset in assets {
            APICaller.shared.getChartDataWithSplitsAndDividends(searchSymbol: asset.stock.wrappedSymbol, range: "max") { connectionResult in
                switch connectionResult {
                case .success(let array):
                    print("We should never get this: \(array)")
                case .chartSuccess(let chartData):
                    self.updateDividendsToTransactions(chartData: chartData, context: context)
                    self.updateSplitsToTransactions(chartData: chartData, context: context)
                case .failure(let string):
                    print("Error loading dividends and splits for \(string)")
                }
            }
        }
    }
    
    func updateDividendsToTransactions(chartData: ChartData, context: NSManagedObjectContext)
    {
        for asset in assets {
            for t in asset.transactions {
                if let events = chartData.events, let thedividends = events.dividends {
                    print("found \(thedividends.count) dividends")
                    for d in thedividends {
                        let price = chartData.priceAtOpenOnDate(date: d.value.date) ?? asset.stock.regularMarketPrice
                        t.addAndApplyDividendIfValid(dividend: d.value, dateOfRecord: d.key, stockPriceAtDividend: price, context: context)
                    }
                }
            }
        }
    }
    
    func updateSplitsToTransactions(chartData: ChartData, context: NSManagedObjectContext)
    {
        for asset in assets {
            for t in asset.transactions {
                if let events = chartData.events, let thesplits = events.splits {
//                    print("found \(thesplits.count) splits")
                    for s in thesplits {
                        t.addAndApplySplitIfValid(split: s.value, dateOfRecord: s.key, context: context)
                    }
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
    

}
