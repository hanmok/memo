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
    
    init(currentFolder: Folder, inFolder: Bool = false) {
        self.currentFolder = currentFolder
        self.inFolder = inFolder
    }
    
    let inFolder: Bool
    
    
    var body: some View {
        // If it is trashFolder, then print with `RED` Color
        if FolderType.compareName(currentFolder.title, with: .trashbin) {
            Text(getRoot(child:currentFolder))
                .font(.caption)
                .foregroundColor(.red)
        }
        else {
            Text(getRoot(child:currentFolder))
                .foregroundColor(Color.blackAndWhite)
                .font(.caption)
        }
    }
    
    // MARK: - Functions
    func getRoot(child: Folder) -> String {
        let parentFoldersInOrder = getAllParents(child: child) // of Type [Folder], inverse order
        print("--------start Printing parentFoldersInOrder: --------")
        
        parentFoldersInOrder.forEach {
            print($0.title)
        }
        print(" ------------end-------- \n\n\n\n\n")
        // compare hierarchy's title with topFolder title for both languages
        
        if parentFoldersInOrder.count == 1 { // Count == 1 -> Basic Folder
            if FolderType.compareName(parentFoldersInOrder.first!.title, with: .folder) {
                // print no folderName for basic Folder. For Other cases, print !
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
            if FolderType.compareName(each.title, with: .folder) && each.parent == nil{
                
            } else {
                    root = "\(each.title)" + " > " + root
            }
        }
        
        if let lastIndex = root.lastIndex(of: ">") {
            root.remove(at: lastIndex)
        }
        // in folderView, it it has no `>`, means almost top Level, don't show any text for hierarchyLabel
        if inFolder && !root.contains(">") {
            return ""
        }
        
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
}
