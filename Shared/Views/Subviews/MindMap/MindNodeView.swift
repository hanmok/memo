//
//  MindNodeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

struct MindNodeView: View {
    var folder: Folder
    var subfolders: [Folder] {
//        if hasSubFolder {
            return folder.subFolders!
//        }
    }
    
    var hasSubFolder: Bool {
        return folder.subFolders != nil
    }
    
    var body: some View {
//CollapsibleView
        Collapsible(label: folder.title) {
            VStack {
                ForEach(subfolders) { subfolder in
                    
                }
            }
        }
    }
}

struct MindNodeView_Previews: PreviewProvider {
    static var previews: some View {
        MindNodeView(folder: deeperFolder)
    }
}
