//
//  CircleButton.swift
//  CryptoApp
//
//  Created by Christopher Walter on 4/14/22.
//

import SwiftUI

struct CircleButton: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10, x: 0, y: 0)
            .padding()
        
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButton(iconName: "info")
                .padding()
                .previewLayout(.sizeThatFits)
            CircleButton(iconName: "plus")
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}
