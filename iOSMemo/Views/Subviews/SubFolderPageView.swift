//
//  SUbFolderPageView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/07.
//

import SwiftUI

struct SubFolderPageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let folder: Folder
    var subfolders: [Folder] {
        let sortedOldFolders = folder.subfolders.sorted()
        return sortedOldFolders
    }
    
    var body: some View {
        // MARK: - SubFolder List
        ScrollView(.horizontal) {
            ForEach(subfolders) { subfolder in
                NavigationLink(
                    destination: FolderView(currentFolder: folder)) {
                        FolderLabelView(folder: folder)
                    }
                    .padding(.horizontal, Sizes.overallPadding)
                    .padding(.vertical, Sizes.minimalSpacing)
            }
        }
        .background(Color.blue)
        // Tool bar on the top
        .overlay {
            HStack {
                Spacer()
                VStack {
                    SubFoldersToolView()
                    Spacer()
                }
            }
        }
    }
}


struct SubFolderPageView_Previews: PreviewProvider {
    
    static var testFolder  = Folder(title: "test Folder", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        SubFolderPageView(folder: testFolder)
    }
}

