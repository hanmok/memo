//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData

struct DynamicTopFolderCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var folder: Folder
    
    var level: Int
    
    var body: some View {
        NavigationLink(destination: FolderView(currentFolder: folder)
                        .environmentObject(trashBinVM)
        ) {
            TitleWithLevelView(folder: folder, level: level)
        } // end of NavigationLink
        
        .listRowBackground(colorScheme == .dark ? Color(white: 0.1) : Color(white: 0.94))
        
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                // DO NOTHING
            } label: {
                ChangeableImage(imageSystemName: "multiply")
            }
            .tint(.gray)
        }
    }
}
