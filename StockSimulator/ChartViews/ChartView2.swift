//
//  ChartView2.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/28/22.
//

import SwiftUI

struct ChartView2: View {
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    let medY: Double
    let q1: Double
    let q3: Double
    let lineColor: Color
    
    init() {
        data = ChartMockData.oneMonth
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        medY = (maxY + minY) / 2
        q1 =  (medY + minY) / 2
        q3 = (maxY + medY) / 2
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        
        lineColor = priceChange > 0 ?  Color.theme.green : Color.theme.red
    }
    var body: some View {
        chartView2
            .frame(height: 200)
            .background(
                chartBackground
            )
            .overlay(chartYAxis, alignment: .leading)
                
            
    }
}

struct ChartView2_Previews: PreviewProvider {
    static var previews: some View {
        ChartView2()
    }
}


extension ChartView2 {
    
    private var chartView2: some View {
        GeometryReader { geometry in
            Path {
                path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index+1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text("\(maxY.formattedWithAbbreviations())")
            Spacer()
            Text("\(q3.formattedWithAbbreviations())")
            Spacer()
            Text("\(medY.formattedWithAbbreviations())")
            Spacer()
            Text("\(q1.formattedWithAbbreviations())")
            Spacer()
            Text("\(minY.formattedWithAbbreviations())")
        }
    }
    
    
}
