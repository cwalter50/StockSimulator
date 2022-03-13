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
            Text(account.wrappedName)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            VStack(alignment: .trailing){
                Text(String(format: "$%.2f", account.currentValue))
                    .font(.headline)
                Text(account.percentChange)
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
