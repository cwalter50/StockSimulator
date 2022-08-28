//
//  StatisticRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/26/22.
//

import SwiftUI

struct StatisticRow: View {
    
    let stat: StatisticModel
    
    var body: some View {
        HStack(spacing: 15) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Spacer()
            
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees:(stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(stat.percentageChange?.asDecimalWith2Decimals() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
            Text(stat.value)
                .font(.caption)
                .foregroundColor(Color.theme.accent)
            
            
        }
        
    }
}

struct StatisticRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StatisticRow(stat: dev.stat1)
//                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            StatisticRow(stat: dev.stat2)
//                .previewLayout(.sizeThatFits)
            StatisticRow(stat: dev.stat3)
//                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }

    }
}