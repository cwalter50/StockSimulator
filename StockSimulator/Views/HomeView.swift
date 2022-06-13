//
//  HomeView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/13/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button(action: {
                APICaller.shared.getMarketData()
            }) {
                Text("GetMarketData")
            }
        }
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
