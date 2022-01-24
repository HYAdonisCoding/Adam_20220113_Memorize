//
//  EmojiArtDocumentView.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/20.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    @State private var choosePalette = ""

    var body: some View {
        VStack {
            HStack {
                PaletteChooser(document: self.document, choosePalette: $choosePalette)
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(choosePalette.map{ String($0) }, id: \.self ) { emoji in
                            Text(emoji)
                                .font(Font.system(size: defaultEmojiSize))
                                .onDrag {
                                    return NSItemProvider(object: emoji as NSString)
                                }
                        }
                    }
                    .padding()
                    
                }
                .onAppear { self.choosePalette = self.document.defaultPalette }
//                .layoutPriority(1)
                Button(action: {
                    document.trash()
//                    self.document = EmojiArtDocument.init()
                }) {
                    Image(systemName: "trash").imageScale(.large).padding()
                }
            }
            
            GeometryReader { geometry in
                ZStack {
                    Color.purple.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(zoomScale)
                            .offset(panOffset)
                    )
                        .gesture(self.doubleTapToZoom(in: geometry.size))
                    if self.isLoading {
//                        Image(systemName: "timer").imageScale(.large).spinning()
                        Image(systemName: "hourglass").imageScale(.large).spinning()

                    } else {
                        ForEach(self.document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                                .offset(panOffset)
                        }
                    }
                }
                .clipped()
                .gesture(panGesture())
                .gesture(zoomGesture())
                .onReceive(self.document.$backgroundImage) { image in
                    zoomToFit(image, in: geometry.size)
                }
                .edgesIgnoringSafeArea([.bottom, .horizontal])
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }
    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGesutreScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGesutreScale
            }
            .onEnded { finalGestureScale in
                steadyStateZoomScale *= finalGestureScale
            }
    }
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { lastestDragGestureValue, gesturePanOffset, transition in
                gesturePanOffset = lastestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalGragGestureValue in
                withAnimation(.linear(duration: 0.25)) {
                    
                    self.steadyStatePanOffset = self.steadyStatePanOffset + (finalGragGestureValue.translation / zoomScale)
                }
            }
        
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded { _ in
                withAnimation(.linear(duration: 3)) {
                    
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
        
    }
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            self.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }

    
    func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)

        location = CGPoint(x: location.x + size.width/2, y: location.y + size.width/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)

        return location
    }
    
    func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            print("droped \(url)")
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { emoji in
                self.document.addEmoji(emoji, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument.init())
    }
}
