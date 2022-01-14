//
//  ContentView.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            ForEach(0..<4) { idx in
                
                CardView(isFaceUp: ((idx & 1) == 0))
                
            }
        }
        .padding()
        .foregroundColor(.orange)
        .font(.largeTitle)
        
    }
}

struct CardView: View {
    var isFaceUp: Bool = true
    
    var body: some View {
        ZStack() {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .foregroundColor(.orange)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 3)
                Text("👻")
            } else {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
