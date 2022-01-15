//
//  Array+Identifiable.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/15.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIdenx(matching: Element) -> Int? {
        for idx in 0..<self.count {
            if self[idx].id == matching.id {
                return idx
            }
        }
        return nil
    }
}
