//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData

struct DynamicFolderCell: View {
    
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
    }
}
