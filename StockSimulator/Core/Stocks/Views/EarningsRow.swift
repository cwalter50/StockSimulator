//
//  EarningsRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/26/22.
//

import SwiftUI

struct EarningsRow: View {
    
    var earnings: EarningsModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(earnings.title)
                .font(.headline)
                .fontWeight(.bold)
            Divider()
            if let actual = earnings.actual {
                
                StatisticRow(stat: StatisticModel(title: "Actual", value: actual.asDecimalWith2Decimals(), percentageChange: earnings.estimate != nil ? actual - (earnings.estimate ?? actual) : nil))
            }
            if let estimate = earnings.estimate {
                StatisticRow(stat: StatisticModel(title: "Estimate", value: estimate.asDecimalWith2Decimals()))
            }
            if let revenue = earnings.revenue {
                StatisticRow(stat: StatisticModel(title: "Revenue", value: Double(revenue).formattedWithAbbreviations()))
            }
            if let earnings = earnings.earnings {
                StatisticRow(stat: StatisticModel(title: "Earnings", value: Double(earnings).formattedWithAbbreviations()))
            }
        }
        
    }
}

struct EarningsRow_Previews: PreviewProvider {
    static var previews: some View {
        EarningsRow(earnings: dev.earnings1)
    }
}
