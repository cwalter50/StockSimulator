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

    @StateObject private var dataController: DataController = DataController()
//    @StateObject private var vm: AccountViewModel
    @StateObject private var stockVM = StocksViewModel()
    @StateObject private var marketSummaryVM = MarketSummaryViewModel()
    
//    init(){
//        let dataController = DataController()
//        _dataController = StateObject(wrappedValue: dataController) // core Data from 100 days SwiftUI Project 11
////        _vm = StateObject(wrappedValue: AccountViewModel(account: Account(context: dataController.container.viewContext)))
//    }
    
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(stockVM)
                    .environmentObject(marketSummaryVM)
    //                .environmentObject(dataController)
    //                .environmentObject(vm)
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                    }
                }
            }
            
        }
    }
}
