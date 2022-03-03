//
//  AccountRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import SwiftUI

struct AccountRow: View {
    
    var account: Account
    
    var body: some View {
        HStack (alignment: .lastTextBaseline){
            Text(account.name ?? "NoName")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            VStack(alignment: .trailing){
                Text(String(format: "$%.2f", account.calculateValue()))
                    .font(.headline)
                Text(account.calculatePercentChange())
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(account: Account())
    }
}
