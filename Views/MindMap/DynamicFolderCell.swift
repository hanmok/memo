//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData

struct DynamicFolderCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var folder: Folder
    
    @State var showingDeleteAction = false
    
    var level: Int
    
    var body: some View {
        ZStack {
            NavigationLink(destination: FolderView(currentFolder: folder)
                .environmentObject(trashBinVM)
            ) {
                TitleWithLevelView(folder: folder, level: level)
            } // end of NavigationLink
        }
        .listRowBackground(colorScheme == .dark ? Color(white: 0.1 + Double(level) * 0.04) : Color(white: 0.94 - Double(level) * 0.03))
    }
}
