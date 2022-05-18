//
//  WatchlistsView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/4/22.
//

import SwiftUI

struct WatchlistsView: View {
    @Environment(\.managedObjectContext) var moc // CoreData
    
    @Environment(\.editMode) private var editMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Watchlist.created, ascending: false)], animation: Animation.default) var watchlists: FetchedResults<Watchlist>
    
    @State var isAddWatchlistPresented = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(watchlists) {
                    watchlist in
                    NavigationLink(destination: WatchlistView(watchlist: watchlist)) {
                        Text(watchlist.wrappedName)
                    }
                }
                .onDelete(perform: delete)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddWatchlistPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isAddWatchlistPresented) {
                        AddWatchlistView(name: "")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .navigationTitle("Watchlists")

        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
    func delete(at offsets: IndexSet) {
//        accounts.remove(atOffsets: offsets)
//        saveToUserDefaults()
        
        for index in offsets {
            let watchlist = watchlists[index]
            moc.delete(watchlist)
        }
        
        try? moc.save()
        
    }
    
}

struct WatchlistsView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistsView()
    }
}