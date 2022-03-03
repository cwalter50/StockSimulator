//
//  MainView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/16/22.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State var accounts: [Account]
    
    var body: some View {
        TabView {
            Text("Home Tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
         
            AccountsView()
//                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "bookmark.circle.fill")
                    Text("Accounts")
                }
         
            WatchListView()
//                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "video.circle.fill")
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
    
    func loadAccountsFromUserDefaults()
    {
//        if let theAccounts = UserDefaults.standard.data(forKey: "accounts")
//        {
//            let decoder = JSONDecoder()
//            if let decoded = try? decoder.decode([Account].self, from: theAccounts) {
//                self.accounts = decoded
//                print("loaded from userdefaults")
//                return
//            }
//        }
//        else {
//            print("No record of items in user defaults")
//        }
//        // failed to load anything from user defaults
//        self.accounts = []
    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(accounts: [])
    }
}
