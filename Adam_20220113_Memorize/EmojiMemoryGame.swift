//
//  EmojiMemoryGame.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/14.
//

import Foundation

class EmojiMemoryGame {
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojs = ["👻", "🎃", "🕷"]
        
        return MemoryGame<String>(emojs.count) { emojs[$0] }
    }
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intents(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
