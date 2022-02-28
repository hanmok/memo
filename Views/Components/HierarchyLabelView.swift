//
//  HierarchyLabelView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/21.
//

import SwiftUI

struct HierarchyLabelView: View {
    @Environment(\.colorScheme) var colorScheme
    let currentFolder: Folder
    var isNavigationLink: Bool = false
    
    func getRoot(child: Folder) -> String {
        let hierarchy = getAllParents(child: child)
        
        if hierarchy.count == 1 {
            if hierarchy.first!.title == FolderType.getFolderName(type: FolderTypeEnum.folder) {
                return "\(LocalizedStringStorage.folder)"
            } else {
                return "\(LocalizedStringStorage.archive)"
            }
        }
        
        var root = ""
        
        _ = hierarchy.map { root = "\($0.title)" + " > " + root}
        
        let lastIndex = root.lastIndex(of: ">")!
        root.remove(at: lastIndex)
        return root
    }
    
    func getAllParents(child: Folder) -> [Folder] {
        
        var newChild = child
        var emptyFolder : [Folder] = [newChild]
        
        while(newChild.parent != nil) {
            newChild = newChild.parent!
            emptyFolder.append(newChild)
        }
        
        return emptyFolder
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            
            if isNavigationLink {
                Text(getRoot(child:currentFolder))
                    .font(.caption)
            } else {
            Text(getRoot(child:currentFolder))
                    .foregroundColor(Color.blackAndWhite)
                .font(.caption)
                .opacity(0.5)
            }
        }
        .background(colorScheme == .dark ? .black : .white)
    }
}
