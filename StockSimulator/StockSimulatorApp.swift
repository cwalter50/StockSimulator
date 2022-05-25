//
//  StockSimulatorApp.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/29/22.
//

import SwiftUI

@main
struct StockSimulatorApp: App {
//    let persistenceController = PersistenceController.shared
    
    @StateObject private var dataController = DataController() // core Data from 100 days SwiftUI Project 11

    @StateObject private var stockVM = StocksViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(accounts: [])
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(stockVM)

//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
