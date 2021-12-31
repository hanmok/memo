//
//  CollapsibleFolderList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

// 재사용이 전혀 안되고있음..

struct CollapsibleFolderList: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var folder: Folder
    var subfolders: [Folder] {
        return folder.subFolders!
    }

    var subfoldersHeight: CGFloat {
        if folder.subFolders != nil {
            return CGFloat(folder.subFolders!.count * 20)
        } else { return 0 }
    }
    
    var firstFolderName: String {
        if folder.subFolders != nil {
            return folder.subFolders!.first!.title
        } else {
            return "there's no any subfolder in current folder"
        }
    }
    
//    @State private var collapsed: Bool = true
    
    func navigateToFirstFolder() {
        if folder.subFolders != nil {
            // navigate
        }
    }
    
    var body: some View {
        
        Collapsible(label: "") {
            ScrollView {
                VStack {
                    ForEach(subfolders) { subfolder in
                        NavigationLink(destination: FolderView(folder: subfolder)) {
                            Text(subfolder.title)
                                .tint(.primary)
                            Spacer()
                            ChangeableImage(colorScheme: _colorScheme, imageSystemName: "chevron.right", width: 10, height: 10)
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, Sizes.overallPadding)
                        .frame(maxWidth: .infinity, idealHeight: 20, alignment: .leading)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight:  subfoldersHeight + 30)
            .background(.gray)
            // end of Contents
        }

        .background(.orange)
    }
}

struct CollapsibleFolderList_Previews: PreviewProvider {
    static var previews: some View {
//        CollapsibleFolderList(hasCollapsed: false, folder: deeperFolder)
        CollapsibleFolderList( folder: deeperFolder)
    }
}
