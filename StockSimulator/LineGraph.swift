//
//  LineGraph.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/24/22.
//

import SwiftUI

struct LineGraph: Shape {
    // These are the normalized Data Points between 0 and 1
    var dataPoints: [Double]

    func path(in rect: CGRect) -> Path {

        func point(at ix: Int) -> CGPoint {
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1 - CGFloat(point)) * rect.height

            return CGPoint(x: x, y: y)
        }

        return Path {
            p in
            // remove bad cases where there are less than 2 points
            guard dataPoints.count > 1 else { return }
            let start = dataPoints[0]
            // flip start value y, because y = 0 is top and y = 1 is bottom
            p.move(to: CGPoint(x: 0, y: (1 - CGFloat(start)) * rect.height))

            for i in dataPoints.indices {
                p.addLine(to: point(at: i))
            }

        }
    }
}
