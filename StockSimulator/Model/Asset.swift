//
//  Asset.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import Foundation


class Asset: Identifiable, ObservableObject
{
    @Published var transactions: [Transaction]
    @Published var id: UUID
    @Published var stock: Stock
    

    var totalShares: Double {
        
        var total = 0.0
        for transaction in transactions {
            if transaction.isClosed == false
            {
                total += transaction.numShares
            }
        }
        return total
    }
    
    var averagePurchasePrice: Double {
        
        var sum = 0.0
        for transaction in transactions {
            if transaction.isClosed == false
            {
                sum += transaction.costBasis
            }
        }
        return sum / totalShares
    }
    
    var totalValue: Double {
        return totalShares * stock.regularMarketPrice
    }
    
    var costBasis: Double {
        return averagePurchasePrice * totalShares
    }
    
    var percentChange: Double {
        
        if totalValue >= costBasis
        {
            return 100 * (totalValue / costBasis - 1)
        }
        else {
            return 100 * (1 - totalValue / costBasis)
        }
    }
    
    var amountChange: Double {
        return totalValue - costBasis
    }
    
    init(transactions: [Transaction], stock: Stock)
    {
        self.id = UUID()
        self.transactions = transactions
        self.stock = stock
    }
    
    
    
}

