//
//  DataController.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/2/22.
//

import CoreData
import SwiftUI
import Combine


class DataController: ObservableObject
{
    let container = NSPersistentContainer(name: "StockSimulator")
    
    @Published var savedWatchlists: [Watchlist] = []
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            self.getWatchlists()
//            self.getAccounts()
        }
        
        print("init on DataController called")
    }
    
    // MARK: Public
    func updateWatchlist(snapshot: StockSnapshot, watchlist: Watchlist?)
    {
        // save stock to coredata...
        let newStock = Stock(context: container.viewContext)
        newStock.updateValuesFromStockSnapshot(snapshot: snapshot)

        // make relationship between stock and the watchlist
        if let theWatchlist = watchlist
        {
            // check if stock is already in watchlist
            if let theStocks = theWatchlist.stocks?.allObjects as? [Stock], let found = theStocks.first(where: { $0.wrappedSymbol == snapshot.symbol }){
                // do nothing, because stock is found
                print("Already had stock: \(found.wrappedSymbol) in watchlist. Do nothing.")
            }
            else {
                newStock.addToWatchlists(theWatchlist)
                theWatchlist.addToStocks(newStock)
                save()
                print("saved stock: \(newStock.wrappedSymbol) to watchlist: \(theWatchlist.wrappedName)")
            }
        }
        getWatchlists()
    }
    
    func addWatchlist(name: String)
    {
        // add the WatchList
        let newWatchlist = Watchlist(context: container.viewContext)
        newWatchlist.id = UUID()
        newWatchlist.name = name
        newWatchlist.created = Date()
        
        applyChanges()
    }
    
    func deleteWatchlist(watchlist: Watchlist)
    {
        container.viewContext.delete(watchlist)
        applyChanges()
    }
//    func updatePortfolio(coin: CoinModel, amount: Double)
//    {
//        // check if coin is in portfolio.
//        if let entity = savedEntities.first(where: { $0.coinID == coin.id })
//        {
//            if amount > 0 {
//                update(entity: entity, amount: amount)
//            } else {
//                delete(entity: entity)
//            }
//        } else {
//            add(coin: coin, amount: amount)
//        }
//    }
    
    
    // MARK: Private
    
//    private func getAccounts() {
//        let request = NSFetchRequest<Account>(entityName: "Account")
//        do {
//            accounts = try container.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching entities: \(error)")
//        }
//    }
    private func getWatchlists()
    {
        let request = NSFetchRequest<Watchlist>(entityName: "Watchlist")
        do {
            savedWatchlists = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching entities: \(error)")
        }
    }
    
    
//    private func add(coin: CoinModel, amount: Double) {
//        let entity = PortfolioEntity(context: container.viewContext)
//        entity.amount = amount
//        entity.coinID = coin.id
//        applyChanges()
//    }
    
    private func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error {
                print("Error saving to Core Data: \(error)")
            }
        }
        
    }
    
    private func applyChanges()
    {
        save()
        getWatchlists() // fetch all watchlists from context, which includes new one
    }
    
//    private func update(entity: Watchlist, amount: Double)
//    {
//        entity.amount = amount
//        applyChanges()
//    }
    
    
    

}

