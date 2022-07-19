//
//  TransactionsView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/19/22.
//

import SwiftUI

struct TransactionsView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest var transactions: FetchedResults<Transaction> // transaction need load in init, because FetchRequest requires a predicate with the variable account
    
    var account: Account
    
    init(account: Account) {
        self.account = account
        
        self._transactions = FetchRequest(entity: Transaction.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.buyDate, ascending: true)], predicate: NSPredicate(format: "(ANY account == %@)", self.account), animation: Animation.default)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(transactions) { t in
                    Text("\(t.eventType ?? "UnKnown"): \(t.numShares) of \(t.stock?.wrappedSymbol ?? "UnKnown")")
                }
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        let account = dev.sampleAccount()
        TransactionsView(account: account)
    }
}
