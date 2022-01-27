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
    @State private var showPaletteEditor = false
    var body: some View {
        HStack {
            VStack {
                Text(self.document.paletteNames[self.choosePalette] ??
                     "NO Name")
                
                Stepper(onIncrement: {
                    self.choosePalette = self.document.palette(after: self.choosePalette)
                }, onDecrement: {
                    self.choosePalette = self.document.palette(before: self.choosePalette)
                }, label: { EmptyView() })
            }
            
            
            
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    self.showPaletteEditor.toggle()
                }//popover sheet
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor(choosenPalette: $choosePalette, isShowing: $showPaletteEditor)
                        .environmentObject(document)
                        .frame(minWidth: 300, minHeight: 500)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
//        .onAppear { self.choosenPalette = self.document.defaultPalette }
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    @Binding var choosenPalette: String
    @Binding var isShowing: Bool

    @State private var paletteName = ""
    @State private var emojisToAdd = ""
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor").font(.headline).padding()
                HStack{
                    Spacer()
                    Button(action: {isShowing = false}, label: { Text("Done") }).padding()
                }
            }
            
                
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { begin in
                        if !begin {
                            self.document.renamePalette(choosenPalette, to: paletteName)
                        }
                    })
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { begin in
                        if !begin {
                            choosenPalette = document.addEmoji(emojisToAdd, toPalette: choosenPalette)
                            emojisToAdd = ""
                        }
                    })
                }
                Section(header: Text("Remove Emoji")) {

                    Grid(choosenPalette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: fontSize))
                            .onTapGesture {
                                choosenPalette = document.removeEmoji(emoji, fromPalette: choosenPalette)
                            }
                    }
                    .frame(height: height)
                }
            }
            

            
        }
        .onAppear {
            self.paletteName = document.paletteNames[choosenPalette] ?? ""
            
        }
    }
    // MARK: - Drawing Constants
    
    private var height: CGFloat {
        CGFloat(((choosenPalette.count - 1) / 6 ) * 70 + 70)
    }
    let fontSize: CGFloat = 40
    
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), choosePalette: Binding.constant("Faces"))
    }
}
