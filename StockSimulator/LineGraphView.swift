//
//  LineGraphView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/9/22.
//

import SwiftUI

struct LineGraphView: View {
    var data: [CGFloat]
    
    @State var currentPlot = ""
    
    @State var offset: CGSize = .zero
    
    @State var showPlot = false
    
    @State var translation: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            let maxPoint = (data.max() ?? 0) + 100
            let points = data.enumerated().compactMap {
                item -> CGPoint in
                // getting progress and multiplying with the height
                let progress = item.element / maxPoint
                
                let pathHeight = progress * height

                // width
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            ZStack {

                // Path...
                Path { path in
                    // drawing the points
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(colors: [
                        Color.theme.green,
                        Color.theme.red
                    ], startPoint: .leading, endPoint: .trailing)
                )
                
                // Path Background Coloring
                fillBG()
                .clipShape(
                    Path { path in
                        path.move(to: CGPoint.zero)
                        path.addLines(points)
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                )
                .padding(.top, 12)
            }
            .overlay(
                // Drag indicator
                VStack(spacing: 0) {
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.theme.green, in: Capsule())
                        .offset(x: translation < 10 ? 30: 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    Rectangle()
                        .fill(Color.theme.green)
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    Circle()
                        .fill(Color.theme.green)
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        )
                    Rectangle()
                        .fill(Color.theme.green)
                        .frame(width: 1, height: 55)
                    
                    
                }
                // Fixed Frame
                // For Gesture Calculation...
                    .frame(width: 80, height: 170)
                    // 170 / 2 = 185 - 15 => circle ring size
                    .opacity(showPlot ? 1 : 0)
                    .offset(y: 70)
                    .offset(offset),
//                    .opacity(showPlot ? 1 : 0)
                alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({
                value in
                withAnimation{
                    showPlot = true
                }
                let translation = value.location.x - 40
                
                // getting index...
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                
                currentPlot = "$ \(data[index])"
                self.translation = translation
                // removing half width
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                
            }).onEnded({ value in
                withAnimation {
                    showPlot = false
                }
            }))
        }
        .overlay(
            VStack(alignment: .leading) {
                let max = data.max() ?? 0
                
                Text("$ \(Int(max))")
                    .font(.caption.bold())
                Spacer()
                Text("$ 0")
                    .font(.caption.bold())
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal, 10)
        
    }
    
    @ViewBuilder func fillBG() -> some View {
        LinearGradient(colors: [
            Color.theme.green.opacity(0.3),
            Color.theme.green.opacity(0.2),
            Color.theme.green.opacity(0.1)] + Array(repeating: Color.theme.red.opacity(0.1), count: 4) + Array(repeating: Color.clear, count: 2)
        , startPoint: .top, endPoint: .bottom)
    }
}

struct LineGraphView_Previews: PreviewProvider {
    static var previews: some View {
//        LineGraphView()
        HomeView2()
    }
}
