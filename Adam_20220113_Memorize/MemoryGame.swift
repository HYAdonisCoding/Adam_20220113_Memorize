//
//  MemoryGame.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/14.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func choose(_ card: Card) {
        print("card choose the: \(card)")
//        card.isFaceUp.toggle()
    }
    init(_ numberOfPairsOfCards: Int, _ cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        
        var content: CardContent
        
        var id: Int
    }
}
