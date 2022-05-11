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
    //    var isNavigationLink: Bool = false
    
    func getRoot(child: Folder) -> String {
        let parentFoldersInOrder = getAllParents(child: child)
        
        // compare hierarchy's title with topFolder title for both languages
        
        if parentFoldersInOrder.count == 1 {
            if FolderType.compareName(parentFoldersInOrder.first!.title, with: .folder) {
                // print no folderName for basic Folder
                return ""
            } else if FolderType.compareName(parentFoldersInOrder.first!.title, with: .archive){
                return "\(LocalizedStringStorage.archive)"
            } else if FolderType.compareName(parentFoldersInOrder.first!.title, with: .trashbin) {
                return "\(LocalizedStringStorage.trashbin)"
            }
        }
        
        var root = ""
        
        // 여기서, 처음이 Folder 인 경우 없애줘야해.
        
        for each in parentFoldersInOrder {
            if FolderType.compareName(each.title, with: .folder) && each.parent == nil {
                
            } else {
                root = "\(each.title)" + " > " + root
            }
        }
        
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
        if FolderType.compareName(currentFolder.title, with: .trashbin) {
            Text(getRoot(child:currentFolder))
                .font(.caption)
                .foregroundColor(.red)
            //                    .background(colorScheme == .dark ? .black : .white)
        }
        else {
            Text(getRoot(child:currentFolder))
                .foregroundColor(Color.blackAndWhite)
                .font(.caption)
        }
    }
}
