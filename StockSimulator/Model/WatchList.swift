////
////  WatchList.swift
////  StockSimulator
////
////  Created by Christopher Walter on 2/1/22.
////
//
//import Foundation
//import SwiftUI
//
//
//class WatchList: ObservableObject
//{
////    var stocks: [Stock]
//    
////    var id: Int // needed for Codeable
//    @Published var stocks: [Stock] {
//        didSet {
//////            print("didSet is called on stocks")
////            let encoder = JSONEncoder()
////            if let encoded = try? encoder.encode(stocks) {
////                UserDefaults.standard.set(encoded, forKey: "watchlistStocks") // everytime we add a new stock, this will update the data in Userdefaults
//////                print("saving watchListStocks to UserDefaults")
////            }
////            else {
////                print("failed to save anything to user defaults")
////            }
//            
//        }
//    }
//    
//    init(stocks: [Stock])
//    {
////        id = UUID().hashValue
//        self.stocks = stocks
//    }
//    
//    init() { // this will check if there are items in UserDefaults, and decode them into [Activity]. If none exist, then it will make items an empty array
////        print("init from watchlist")
//        self.stocks = []
//        loadFromUserDefaults()
//    }
//    
//    
//    // This might not be needed, because I added this in the didSet method. It appears to be working everytime we append or remove from the list.
//    func saveToUserDefaults()
//    {
////        let encoder = JSONEncoder()
////        if let encoded = try? encoder.encode(stocks) {
////            UserDefaults.standard.set(encoded, forKey: "watchlistStocks") // everytime we add a new stock, this will update the data in Userdefaults
////            print("saving items to UserDefaults")
////        }
////        else {
////            print("failed to save anything to user defaults")
////        }
//    }
//    
//    func loadFromUserDefaults()
//    {
////        if let theStocks = UserDefaults.standard.data(forKey: "watchlistStocks")
////        {
////            let decoder = JSONDecoder()
////            if let decoded = try? decoder.decode([Stock].self, from: theStocks) {
////                self.stocks = decoded
////                print("loaded from userdefaults")
////                return
////            }
////        }
////        else {
////            print("No record of items in user defaults")
////        }
////        // failed to load anything from user defaults
////        self.stocks = []
//    }
//    
//}
