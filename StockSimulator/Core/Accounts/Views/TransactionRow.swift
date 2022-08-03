//
//  TransactionRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/21/22.
//

import SwiftUI

struct TransactionRow: View {
    
    var transaction: Transaction
    var body: some View {
        VStack {
            HStack {
                Text("\(transaction.eventType ?? "Unknown"): ")
                    .font(.headline)
                Spacer()
                Text("Cost Basis: \(transaction.costBasis.asCurrencyWith6Decimals())")
                    .font(.headline)
                    .foregroundColor(Color.theme.green)

            }
            HStack {
                Text("\(transaction.wrappedBuyDate.asShortDateString())")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.secondaryText)
                Spacer()
                Text("\(transaction.numShares > 0.01 ? transaction.numShares.formattedWithAbbreviations(): transaction.numShares.asDecimalWith6Decimals()) shares of \(transaction.stock?.wrappedSymbol ?? "Unknown") at price \(transaction.purchasePrice.asCurrencyWith2Decimals())")
                    .font(.body)
                    .foregroundColor(Color.theme.secondaryText)
                
            }
        }
        
        
        
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: dev.sampleTransaction)
    }
}
