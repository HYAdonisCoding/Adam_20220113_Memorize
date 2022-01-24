//
//  Spinning.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/24.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State private var isVisible = false
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
            .onAppear {
                self.isVisible = true
            }
    }
}


extension View {
    func spinning() -> some View {
        self.modifier(Spinning())
    }
}
