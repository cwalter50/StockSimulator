//
//  ContentView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/29/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State var accounts: [Account]
    
    var body: some View {
        TabView {
            VStack {
                Text("Home Tab")
            }
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
         
            AccountsView()
                .tabItem {
                    Image(systemName: "dollarsign.square.fill")
                    Text("Accounts")
                }
         
            WatchlistsView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("WatchLists")
                }
         
            Text("Profile Tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(accounts: [])
            .environment(\.managedObjectContext, dev.dataController.container.viewContext)
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

            
            
    }
}

