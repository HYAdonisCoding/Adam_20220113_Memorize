//
//  PaletteChooser.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/24.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument

    @Binding var choosePalette: String
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                self.choosePalette = self.document.palette(after: self.choosePalette)
            }, onDecrement: {
                self.choosePalette = self.document.palette(before: self.choosePalette)
            }, label: { EmptyView() })
            
            Text(self.document.paletteNames[self.choosePalette] ??
                 "NO Name")
        }
        .fixedSize(horizontal: true, vertical: false)
//        .onAppear { self.choosePalette = self.document.defaultPalette }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), choosePalette: Binding.constant("Faces"))
    }
}
