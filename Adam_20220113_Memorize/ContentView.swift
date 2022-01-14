//
//  ContentView.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/13.
//

import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    var body: some View {
        HStack {
            ForEach(viewModel.cards) { card in
                
                CardView(card: card)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
                
            }
        }
        .padding()
        .foregroundColor(.orange)
        .font(.largeTitle)
        
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack() {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .foregroundColor(.orange)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 3)
                Text(card.content)
            } else {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
