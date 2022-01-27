//
//  EmojiArtDocument.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/20.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable {
    
    let id: UUID
    
    static func ==(lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let paletts: String = "⭐️🌧🍎🌍🍩🌰😈🐶🦖🐢🦟🐝🐳🌲🌈🔥🌽"
    
    @Published private var emojiArt: EmojiArt
    
    private var autosaveCancellable: AnyCancellable?
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultKey = "EmojiArtDocument.\(self.id.uuidString)"

        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultKey)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink { emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: defaultKey)
            print("json = \(emojiArt.json?.utf8 ?? "nil")")
        }
        fetchBackgroundImageData()
    }
    @Published private(set) var backgroundImage: UIImage?
    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize = .zero

    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func trash() {
//        UserDefaults.standard.set("", forKey: EmojiArtDocument.untitled)

    }
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    @State private var fetchImageCancellabel: AnyCancellable?
    
    private func fetchBackgroundImageData() {
//        if let url = self.emojiArt.backgroundURL {
//            backgroundImage = nil
//            fetchImageCancellabel?.cancel()
//            fetchImageCancellabel = URLSession.shared.dataTaskPublisher(for: url)
//                .map { data, urlResponse in UIImage(data: data) }
//                .receive(on: DispatchQueue.main)
//                .replaceError(with: nil)
//                .assign(to: \.backgroundImage, on: self)
//        }
        if let url = self.emojiArt.backgroundURL {
            print("start downloading \(url)")
            backgroundImage = nil
            var request = URLRequest.init(url: url)
            request.timeoutInterval = 15
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (error != nil) {
                    print("error: \(error?.localizedDescription ?? "error")")
                }
                guard let imageData = data else {
                    print("no data back")
                    print("error: \(error?.localizedDescription ?? "error")")
                    return
                }
                DispatchQueue.main.async {
                    if url == self.emojiArt.backgroundURL {
                        self.backgroundImage = UIImage(data: imageData)
                    }
                }
            }
            task.resume()

        }
    }
        
    
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
