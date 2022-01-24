//
//  EmojiArtDocument.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/20.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
    
    static let paletts: String = "⭐️🌧🍎🌍🍩🌰😈🐶🦖🐢🦟🐝🐳🌲🌈🔥🌽"
    
    @Published private var emojiArt: EmojiArt
    
    private var autosaveCancellable: AnyCancellable?
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink { emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
            print("json = \(emojiArt.json?.utf8 ?? "nil")")
        }
        fetchBackgroundImageData()
    }
    @Published private(set) var backgroundImage: UIImage?
    
    private static let untitled = "EmojiArtDocument.Untitled"

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
        UserDefaults.standard.set("", forKey: EmojiArtDocument.untitled)

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
        if let url = self.emojiArt.backgroundURL {
            backgroundImage = nil
            fetchImageCancellabel?.cancel()
            fetchImageCancellabel = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
//        if let url = self.emojiArt.backgroundURL {
//            backgroundImage = nil
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                guard let imageData = data else {
//                    print("no data back")
//                    print("error: \(error?.localizedDescription ?? "error")")
//                    return
//                }
//                DispatchQueue.main.async {
//                    if url == self.emojiArt.backgroundURL {
//                        self.backgroundImage = UIImage(data: imageData)
//                    }
//                }
//            }
//            task.resume()
//
//        }
    }
        
    
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
