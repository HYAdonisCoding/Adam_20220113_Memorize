//
//  EmojiArtDocumentChooser.swift
//  Adam_20220120_EmojiArt
//
//  Created by Adam on 2022/1/26.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    @State private var editMode: EditMode = .inactive
    var body: some View {
        
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    NavigationLink(destination:
                                    EmojiArtDocumentView(document: document)
                                    .navigationBarTitle(Text(store.name(for: document)), displayMode: .inline)
                                   
                    ) {
                        EditableText(self.store.name(for: document), isEditing: editMode.isEditing) { name in
                            store.setName(name, for: document)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { store.documents[$0] }.forEach { document in
                        store.removeDocument(document)
                    }
                }
            }
            .navigationBarTitle(Text(store.name), displayMode: .automatic)
            .navigationBarItems(
                leading: Button(action: {
                    self.store.addDocument()
                }) {
                    Image(systemName: "plus").imageScale(.large)
                },
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
        
//        .onAppear {
//            store.addDocument()
//            store.addDocument(named: "Hello word")
//        }
        
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
