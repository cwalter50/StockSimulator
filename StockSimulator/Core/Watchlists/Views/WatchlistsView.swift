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
    
//    @EnvironmentObject var vm: StocksViewModel
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
            .listStyle(.plain)
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
        .navigationViewStyle(.stack)
       
//        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let watchlist = watchlists[index]
//            vm.deleteWatchlist(watchlist: watchlist)
            moc.delete(watchlist)
        }
        try? moc.save()
    }
}

struct WatchlistsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = dev.dataController.container.viewContext
        return WatchlistsView()
            .environment(\.managedObjectContext, context)
//            .environment(\.managedObjectContext, dev.dataController.container.viewContext)
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//            .environmentObject(dev.stockVM)

        
    }
}
