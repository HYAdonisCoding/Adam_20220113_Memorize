//
//  Array+Only.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/15.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
