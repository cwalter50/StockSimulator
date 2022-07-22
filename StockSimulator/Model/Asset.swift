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
    
    var isClosed: Bool {
        for t in transactions {
            if t.isClosed == false {
                return false
            }
        }
        return true
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
        
//        print("\(stock.symbol) percent change = \(percentChange) and totalValue = \(totalValue), cost basis = \(costBasis)")
        if totalValue > costBasis
        {
            return 100 * (totalValue / costBasis - 1)
        }
        else {
            return 100 * (1 - totalValue / costBasis)
        }
    }
    
    var amountChange24h: Double {
        return stock.regularMarketChange * totalShares
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
    
    
    func updateValue()
    {
        APICaller.shared.getQuoteData(searchSymbols: stock.wrappedSymbol, completion: { result in
        
            switch result {
            case .success(let snapshots):
                if let stockSnapshot = snapshots.first(where: { $0.symbol == self.stock.wrappedSymbol })
                {
                    self.stock.updateValuesFromStockSnapshot(snapshot: stockSnapshot)
                }
            default:
                print("Error updating asset value")
                
            }
        })
    }
    
    
    
}

