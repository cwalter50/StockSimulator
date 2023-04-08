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
                Spacer()
                Text("\(transaction.stock?.wrappedSymbol ?? "Unknown")")
                    .foregroundColor(Color.theme.buttonColor)
                Text("\(transaction.numShares > 0.01 ? transaction.numShares.formattedWithAbbreviations(): transaction.numShares.asDecimalWith6Decimals())")
//                    .foregroundColor(Color.theme.secondaryText)
            }
            .font(.headline)
            HStack {
                VStack {
                    Text("Buy: \(transaction.wrappedBuyDate.asShortDateString())")
                    if transaction.isClosed {
                        Text("Sell: \(transaction.wrappedSellDate.asShortDateString())")
                    }
                }
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryText)
                Spacer()
                VStack {
                    Text("Cost Basis")
                    Text("\(transaction.costBasis.asCurrencyWith2Decimals())")

                }
                if transaction.isClosed {
                    VStack {
                        Text("Total Proceeds")
                        Text("\(transaction.totalProceeds.asCurrencyWith2Decimals())")
                    }
                    VStack {
                        Text("Net")
                        Text("\(transaction.netProfit.asCurrencyWith2Decimals())")
                            .foregroundColor(transaction.netProfit >= 0 ? Color.theme.green: Color.theme.red)
                    }
                }
//                Text("Cost Basis: \(transaction.costBasis.asCurrencyWith2Decimals())")
//                    .font(.headline)
//                    .foregroundColor(Color.theme.green)
//                Text("\(transaction.numShares > 0.01 ? transaction.numShares.formattedWithAbbreviations(): transaction.numShares.asDecimalWith6Decimals()) shares of \(transaction.stock?.wrappedSymbol ?? "Unknown") at price \(transaction.purchasePrice.asCurrencyWith2Decimals())")
//                    .font(.body)
//                    .foregroundColor(Color.theme.secondaryText)
                
            }
        }
        
        
        
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: dev.sampleTransaction)
    }
}
