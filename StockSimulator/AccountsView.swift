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
                        AddAccountView()
                    }

                }
            }
        }
        .navigationTitle("Accounts")
    }
    
    
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        AccountsView(accounts: [])
    }
}
