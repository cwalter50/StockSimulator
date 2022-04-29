//
//  ChartView2.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/28/22.
//

import SwiftUI

// I built this following a tutorial. It is not in use in the actual app, but I used a lot of the parts to build the actual ChartView
struct ChartView2: View {
    // data contains the [Double] called close of all of the chart Data, as well as [Int] that are the timeStamps that go with that close data
    private let data: ChartData
    private let maxY: Double
    private let minY: Double
    private let medY: Double
    private let q1: Double
    private let q3: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    
    @State private var percentage: CGFloat = 0 // used to animate the graph
    
    
    init() {
        data = ChartMockData.mockData

        
        maxY = data.close.max() ?? 0
        minY = data.close.min() ?? 0
        medY = (maxY + minY) / 2
        q1 =  (medY + minY) / 2
        q3 = (maxY + medY) / 2
        
        let priceChange = (data.close.last ?? 0) - (data.close.first ?? 0)
        
        lineColor = priceChange > 0 ?  Color.theme.green : Color.theme.red
        
        let lastDateTimeInterval = TimeInterval(data.timestamp.last ?? 0)
        let firstDateTimeInterval = TimeInterval(data.timestamp.first ?? 0)
        endingDate = Date(timeIntervalSince1970: lastDateTimeInterval)
        startingDate = Date(timeIntervalSince1970: firstDateTimeInterval)
    }
    var body: some View {
        VStack {
            chartView2
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal,4), alignment: .leading)
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
            
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
                for index in data.close.indices {
                    let xPosition = geometry.size.width / CGFloat(data.close.count) * CGFloat(index+1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data.close[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 10)

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
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
    
    
}
