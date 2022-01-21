//
//  OptionalImage.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/21.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    var body: some View {
        Group {
            
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
    
}
