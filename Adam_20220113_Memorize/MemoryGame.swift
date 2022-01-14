//
//  MemoryGame.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/14.
//

import Foundation

struct MemoryGame {
    var cards: Array<Card>
    
    func choose(_ card: Card) {
        print("choose the: \(card)")
    }
    
    struct Card {
        var isFaceUp: Bool = false
    }
}
