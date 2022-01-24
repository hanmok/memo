//
//  HierarchyLabelView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/21.
//

import SwiftUI

struct HierarchyLabelView: View {
    let currentFolder: Folder
//    var root = ""
    
    func getRoot(child: Folder) -> String {
        let hierarchy = getAllParents(child: child)
        
        if hierarchy.count == 1 {
            return ""
        }
        
        var root = ""
        
        for eachFolder in hierarchy {
            root = "\(eachFolder.title)" + " > " + root
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
        ScrollView(.horizontal) {
            Text(getRoot(child:currentFolder))
        }

    }
}

//struct HierarchyLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        HierarchyLabelView()
//    }
//}