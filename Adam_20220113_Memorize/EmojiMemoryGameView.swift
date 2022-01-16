//
//  EmojiMemoryGameView.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/13.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // @ObservedObject 加上这个修饰后viewModel有变化就可以重新绘制页面了
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        Grid(viewModel.cards) { card in
            CardView(card: card)
                .onTapGesture {
                    viewModel.choose(card)
                }
                .padding(5)
            
        }
        .padding()
        .foregroundColor(.orange)
        
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    @ViewBuilder
    func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack() {
                Group {
                    Pie(
                        startAngle: Angle.degrees(0-90),
                        endAngle: Angle.degrees(110-90),
                        clockwise: true
                    )
                        .padding(5)
                        .opacity(0.4)
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: size)))
                }
                

                
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
        
        

    }
    // MARK: - Drawing Constants
    
    
    let fontScaleFactor: CGFloat = 0.7

    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
