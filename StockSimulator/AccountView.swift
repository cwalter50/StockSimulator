//
//  AccountView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import SwiftUI

struct AccountView: View {
    
    var account: Account
    
    var body: some View {
        NavigationView {
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
                Text("Assests")
                    .font(.headline)
                List {
                    ForEach (account.assets) {
                        asset in
                        StockRow(stock: asset.stock)
                    }
                }
            }
            .padding()
            

            
        }
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: Account())
    }
}
