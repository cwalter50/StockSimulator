//
//  ChartLoader.swift
//  StockSimulator
//
//  Created by Christopher Walter on 4/3/22.
//

import SwiftUI

struct ChartLoader: View {
    private let animation = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
    
    @State var isAtMaxScale = false
    
    private let maxScale: CGFloat = 1.5
    var body: some View {
        VStack{
            Text("Loading")
                .font(.custom("Avenir", size: 16))
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.blue)
                .frame(width: UIScreen.main.bounds.width/2, height: 3)
                .scaleEffect(CGSize(width: isAtMaxScale ? maxScale: 0.01, height: 1.0))
                .onAppear(perform: {
                    withAnimation(animation) {
                        self.isAtMaxScale.toggle()
                    }
                })
        }
    }
}

struct ChartLoader_Previews: PreviewProvider {
    static var previews: some View {
        ChartLoader()
    }
}
