//
//  DividendView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 5/2/23.
//

import SwiftUI

struct DividendView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest var dividends: FetchedResults<Dividend> // dividends need load in init, because FetchRequest requires a predicate with the variable account
    
    var account: Account
    
    init(account: Account) {
        self.account = account
        
        self._dividends = FetchRequest(entity: Dividend.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Dividend.dateOfRecord, ascending: false)], predicate: NSPredicate(format: "(ANY account == %@)", self.account), animation: Animation.default)
    }
    
    var body: some View {
        VStack {
            Text("Total Dividends: \(dividends.count)")
            List {
                ForEach(dividends) {
                    div in
                    HStack {
                        VStack {
                            Text("Date of Record: \(div.dateOfRecord)")
                            Text("Date: \(div.date)")
                        }
                        VStack {
                            Text("Symbol: \(div.wrappedStockSymbol)")
                            Text(String(format: "Stock Price at Date: $%.2f", div.stockPriceAtDate))
                        }
                        Text(String(format: "Amount: %.2f", div.amount))
                    }
                }
                .onDelete(perform: delete)
            }
        }
        
    }
    
    func delete(at offsets: IndexSet) {
    
        for i in offsets {
            let dividend = dividends[i]
            account.removeFromDividends(dividend)
            moc.delete(dividend)
        }
        if moc.hasChanges {
            try? moc.save()
        }
    }
}

struct DividendView_Previews: PreviewProvider {
    static var previews: some View {
        DividendView(account: dev.sampleAccount)
    }
}
