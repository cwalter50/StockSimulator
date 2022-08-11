//
//  HomeView2.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/9/22.
//

import SwiftUI

struct HomeView2: View {
    var body: some View {
        VStack {
            HStack {
                Button {
                
                } label: {
                    Image(systemName: "slider.vertical.3")
                        .font(.title2)
                }
                Spacer()
                Button {
                    
                } label: {
                    Image("walter")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:45, height: 45)
                        .clipShape(Circle())
                }
            }
            .padding()
            .foregroundColor(.black)
            VStack(spacing: 10) {
                Text("Total Balance")
                    .fontWeight(.bold)
                Text("$ 51 200")
                    .font(.system(size: 38, weight: .bold))
            }
            .padding(.top, 20)
            Button {
                
            } label: {
                HStack(spacing: 5) {
                    Text("Income")
                    Image(systemName: "chevron.down")
                }
                .font(.caption.bold())
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.white, in: Capsule())
                .foregroundColor(.black)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.03), radius: 5, x: -5, y: -5)
            }
            // GraphView
            LineGraphView(data: samplePlot)
                .frame(height: 220)
                .padding(.top, 25)
            Text("Shortcuts")
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    CardView(image: "CWBuildsLogo", title: "CWBuilds", price: "$ 26", color: Color.theme.green)
                    CardView(image: "logo", title: "Stock SImulator", price: "$ 2600", color: Color.theme.green)
                    CardView(image: "yahoologo", title: "Yahoo", price: "$ 120", color: Color.theme.green)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.theme.background)
    }
    
    // card view
    @ViewBuilder func CardView(image: String, title: String, price: String, color: Color) -> some View {
        VStack(spacing: 15) {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .padding()
                .background(color, in: Circle())
            Text(title)
                .font(.title3.bold())
            Text(price)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
        .padding(.vertical)
        .padding(.horizontal, 25)
        .background(.white, in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
        .shadow(color: .black.opacity(0.03), radius: 5, x: -5, y: -5)
    }
}

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2()
    }
}


let samplePlot: [CGFloat] = [
989, 1200, 750, 790, 950, 1200, 600, 500, 600, 890, 1203, 1400, 900, 1250, 1600, 1200
]
