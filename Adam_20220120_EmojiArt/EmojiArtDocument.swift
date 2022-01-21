//
//  EmojiArtDocument.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/20.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    static let paletts: String = "⭐️🌧🍎🌍🍩🌰😈🐶🦖🐢🦟🐝🐳🌲🌈🔥🌽"
    
    @Published private var emojiArt: EmojiArt = EmojiArt()
    
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
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        if let url = self.emojiArt.backgroundURL {
            backgroundImage = nil
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
