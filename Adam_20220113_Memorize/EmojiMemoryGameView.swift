//
//  EmojiMemoryGameView.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/13.
//

import SwiftUI
let duration = 0.50

struct EmojiMemoryGameView: View {
    // @ObservedObject 加上这个修饰后viewModel有变化就可以重新绘制页面了
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        withAnimation(.linear(duration: duration)) {
                            viewModel.choose(card)
                        }
                    }
                    .padding(5)
                    
                
            }
            .padding()
            .foregroundColor(.orange)
            
            Button {
                withAnimation(.easeInOut(duration: duration)) {
                    
                    self.viewModel.resetGame()
                }
            } label: {
                Text("New Game")
            }

        }
        
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    @ViewBuilder
    func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack() {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-animatedBonusRemaining*360-90),
                            clockwise: true
                        )
                            
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(
                            startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-card.bonusRemaining*360-90),
                            clockwise: true
                        )
                    }
                }
                .padding(5)
                .opacity(0.4)
                .transition(.identity)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? .linear(duration: duration*3).repeatForever(autoreverses: false) : .default)
                
                
                
                

                
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
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
