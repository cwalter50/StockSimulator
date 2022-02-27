//
//  AccountView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import SwiftUI

struct AccountView: View {
    
    var account: Account
    
    @State var isSearchPresented = false
    
    var body: some View {
        VStack(alignment: .center){
            HStack(alignment: .firstTextBaseline){
                Text(account.name)
                    .font(.title)
                Spacer()
                Text(String(format: "$%.2f", account.calculateValue()))
                    .font(.headline)
            }
            Text(String(format: "Cash: $%.2f", account.cash))
                .font(.headline)
            HStack(alignment: .firstTextBaseline) {
                Text("Assests")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isSearchPresented.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $isSearchPresented, onDismiss: {
                    // figure out how to load the asset on this page after the asset is bought or sold.
                    
                }){
                    StockSearchView(theAccount: account)
                }

                
                
            }
//            Text("Assests")
//                .font(.headline)
            List {
                ForEach (account.assets) {
                    asset in
                    StockRow(stock: asset.stock)
                }
            }
            
            
        }
        .padding(20)
        .navigationTitle("Account Overview")
//            .navigationBarHidden(true)
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: Account())
    }
}
