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
    
    func testSampleSplit() {

        for t in account.transactions?.allObjects as! [Transaction] {
            if t.isClosed == false {
                let data = ChartMockData.sampleSplitNow
                let testSplit = Split(context: moc)
                if let events = data.events, let thesplits = events.splits {
                    for thesplit in thesplits {
                        testSplit.updateSplitValuesFromChartDataSplit(split: thesplit.value, dateOfRecord: thesplit.key)
                        print("Attempting to add split \(testSplit.splitRatio) to transaction \(t.numShares) shares of \(t.stock!.wrappedSymbol)")
//                        t.addToSplits(<#T##value: Split##Split#>)
                        t.addToSplits(testSplit)
                        t.applySplit(split: testSplit, context: moc)
//                        if (t.splits?.allObjects as! [Split]).contains(where: {$0.id == testSplit.id }) {
//                            let splitRatio = Double(testSplit.numerator) / Double(testSplit.denominator)
//                            t.numShares *= splitRatio
//                            t.purchasePrice /= splitRatio
//                            testSplit.appliedToHolding = true
//                        }
                        // do not save!!! this is only a test
    //                        try? moc.save()
                    }
                }
            }
            
        }
        
    }
    
    func testSampleDividend() {
        for asset in assets {
            for t in asset.transactions {
                let data = ChartMockData.sampleDividendNow
                let testDividend = Dividend(context: moc)
                if let events = data.events, let thedividends = events.dividends {
                    for theDividend in thedividends {
                        testDividend.updateDividendValuesFromChartDataDividend(dividend: theDividend.value, dateOfRecord: theDividend.key, stockPriceAtDate: asset.stock.regularMarketPrice)
                        t.addToDividends(testDividend)
                        t.applyDividend(dividend: testDividend, context: moc)
                        print("Added Dividend \(testDividend.amount) to transaction \(t.numShares) shares of \(t.stock!.wrappedSymbol)")
                    }
                }
            }
        }
    }
    
    func updateSplitsAndDividends() {
        for asset in assets {
            APICaller.shared.getChartDataWithSplitsAndDividends(searchSymbol: asset.stock.wrappedSymbol, range: "max") { connectionResult in
                switch connectionResult {
                case .success(let array):
                    print("We should never get this: \(array)")
                case .chartSuccess(let chartData):
                    self.account.addSplitsAndDividendsToTransactions(chartData: chartData, context: self.moc)
                case .failure(let string):
                    print("Error loading dividends and splits for \(string)")
                }
            }
        }

    }
}
