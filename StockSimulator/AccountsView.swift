//
//  AccountsView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/16/22.
//

import SwiftUI

struct AccountsView: View {
    
    @State var accounts: [Account]
    
    @State var isAddAccountPresented = false
    
    init()
    {
        // load accounts from userDefaults
        accounts = [Account]()
        if let theAccounts = UserDefaults.standard.data(forKey: "accounts")
        {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Account].self, from: theAccounts) {
                accounts = decoded
                print("loaded Accounts from userdefaults")
                return
            }
        }
        else {
            print("No record of accounts in user defaults")
        }
        
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) {
                    account in
                    Text(account.name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddAccountPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isAddAccountPresented){
                        AddAccountView(name: "", startingAmount: "")
                    }

                }
            }
        }
        .navigationTitle("Accounts")
    }
    
    
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        AccountsView()
    }
}
