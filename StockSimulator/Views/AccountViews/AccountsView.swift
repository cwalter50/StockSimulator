//
//  AccountsView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/16/22.
//

import SwiftUI

struct AccountsView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.created, ascending: false)], animation: Animation.default) var accounts: FetchedResults<Account>
    

    @State var isAddAccountPresented = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) {
                    account in
                    NavigationLink(destination: AccountView(account: account)) {
                        AccountRow(account: account)
                    }

                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("hello")
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddAccountPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isAddAccountPresented) {
                        AddAccountView(name: "", startingAmount: "")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .navigationTitle("Accounts")

        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func loadAccountValues()
    {
        for account in accounts {
            
        }
    }
    
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        AccountsView()
    }
}
