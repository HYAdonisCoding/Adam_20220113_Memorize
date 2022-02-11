//
//  EmojiArtDocumentView.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/20.
//

import SwiftUI
import AVFoundation

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    @State private var choosePalette = ""
    
    init(document: EmojiArtDocument) {
        self.document = document;
//        self.choosePalette = self.document.defaultPalette
        _choosePalette = State(wrappedValue: self.document.defaultPalette)
    }

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
//                .onAppear { self.choosenPalette = self.document.defaultPalette }
//                .layoutPriority(1)
            }
            
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
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
                .onDrop(of: ["public.image", "public.jpeg", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    return self.drop(providers: providers, at: location)
                }
                .navigationBarItems(leading: pickImage, trailing: Button(action: {
                    if let url = UIPasteboard.general.url, url != document.backgroundURL {
                        confirmBackgroundPaste = true
                        
                    } else {
                        explainBackgroundPaste.toggle()
                    }
                }) {
                    Image(systemName: "doc.on.clipboard").imageScale(.large)
                        .alert(isPresented: $explainBackgroundPaste) {
                            Alert(
                                title: Text("Paste Background"),
                                message: Text("Copy the URL of an image to the clip board and touch this button to make it the background of your document."),
                                dismissButton: .default(Text("OK")))
                        }
                })
            }
            .zIndex(-1)
        }
        .alert(isPresented: $confirmBackgroundPaste) {
            Alert(
                title: Text("Paste Background"),
                message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                primaryButton: .default(Text("OK")) {
                    self.document.backgroundURL = UIPasteboard.general.url
                }, secondaryButton: .cancel())
        }
    }
    
    @State private var imagePickerSourceType  = UIImagePickerController.SourceType.photoLibrary
    
    private var pickImage: some View {
        HStack {
            Image(systemName: "photo").imageScale(.large).foregroundColor(.accentColor).onTapGesture {
                self.imagePickerSourceType = .photoLibrary
                self.showImagePicker.toggle()
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Image(systemName: "camera").imageScale(.large).foregroundColor(.accentColor).onTapGesture {
                    self.imagePickerSourceType = .camera
                    self.showImagePicker.toggle()
                }
            }
            
        }
        
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imagePickerSourceType: imagePickerSourceType) { image in
                if image != nil {
                    DispatchQueue.main.async {
                        self.document.backgroundURL = image?.storeInFilesystem()
                    }
                }
                self.showImagePicker = false
            }
        }

    }
    @State private var showImagePicker = false

    
    @State private var explainBackgroundPaste = false
    @State private var confirmBackgroundPaste = false

    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    
    private var zoomScale: CGFloat {
        document.steadyStateZoomScale * gestureZoomScale
    }
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGesutreScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGesutreScale
            }
            .onEnded { finalGestureScale in
                document.steadyStateZoomScale *= finalGestureScale
            }
    }
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { lastestDragGestureValue, gesturePanOffset, transition in
                gesturePanOffset = lastestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalGragGestureValue in
                withAnimation(.linear(duration: 0.25)) {
                    
                    self.document.steadyStatePanOffset = document.steadyStatePanOffset + (finalGragGestureValue.translation / zoomScale)
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
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            document.steadyStatePanOffset = .zero
            document.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }

    
    func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)

        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)

        return location
    }
    
    func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        
        var found = providers.loadObjects(ofType: URL.self) { url in
            print("droped \(url)")
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: AVURLAsset.self) { url in
//                let url: URL = AVAsset(url: url)// A local or remote asset URL.
                print("A local or remote asset URL", url)
//                self.document.backgroundURL = url
            }
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
