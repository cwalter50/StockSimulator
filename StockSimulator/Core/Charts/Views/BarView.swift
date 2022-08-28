//
//  BarView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/27/22.
//

import SwiftUI

struct BarView: View {
    var name: String
    var value: Double // estimate
    var maxValue: Double
    var minValue: Double
    var totalHeight: Double // total height of graph
    
    var color: Color

    var range: Double {
        if minValue >= 0 {
            return maxValue
        }
        else if maxValue <= 0 {
            return minValue
        }
        else {
            return maxValue - minValue
        }
    }
    
   
    var body: some View {
        let barHeight = totalHeight / range * abs(value)
        let negativesHeight = minValue < 0 ? (-1 * minValue / range * totalHeight): 0
        let positivesHeight = maxValue > 0 ? abs(maxValue / range * totalHeight): 0
        
        ZStack {
            VStack(spacing: 0) { // Estimate BarChart
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.clear) //
                    .frame(height: value >= 0 ? abs(positivesHeight - barHeight) : abs(positivesHeight))
                RoundedRectangle(cornerRadius: 5.0)
                        .fill(color)
                .frame(height: value >= 0 ? abs(barHeight) : 0)
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(color)
                    .frame(height: value < 0 ? abs(barHeight) : 0)
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.clear)
                    .frame(height: value < 0 ? abs(negativesHeight - barHeight): abs(negativesHeight))
            }
            .frame(width: 50)
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            BarView(name: "1Q2021", value: 1.2, maxValue: 1.8, minValue: -0.8, totalHeight: 300, color: Color.theme.green)
            BarView(name: "2Q2021", value: -0.4, maxValue: 1.8, minValue: -0.8, totalHeight: 300, color: Color.theme.red)
            BarView(name: "3Q2021", value: 0.1, maxValue: 1.8, minValue: -0.8, totalHeight: 300, color: Color.theme.green)
        }
        .background(Color.yellow.opacity(0.1))

    }
}
