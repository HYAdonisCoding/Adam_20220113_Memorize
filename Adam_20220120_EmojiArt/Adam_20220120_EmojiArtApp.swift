//
//  Adam_20220120_EmojiArtApp.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/20.
//

import SwiftUI

@main
struct Adam_20220120_EmojiArtApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        
        WindowGroup {
            
//             let store = EmojiArtDocumentStore(named: "Emoji Art")
            let url = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first!
            
            let store = EmojiArtDocumentStore(directory: url)
//                   store.addDocument()
//                   store.addDocument(named: "Hello word")
//
                EmojiArtDocumentChooser().environmentObject(store)
////            } else {
//
//                EmojiArtDocumentView(document: EmojiArtDocument.init())
//            }
        }.onChange(of: scenePhase) { phase in
            switch phase{
            case .active:
                print("active")
            case .inactive:
                print("inactive")
            case .background:
                print("background")
            @unknown default:
                print("for future")
            }

      }
    }
}
