//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI

struct FastVerCollapsibleFolder: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
//    @ObservedObject var expansion: ExpandingClass
    
    
    let siblingSpacing: CGFloat = 3
    let parentSpacing: CGFloat = 3
    let basicSpacing: CGFloat = 2
    
    var folder: Folder
    
    
//    var shouldExpandOverall: Bool {
//        return !collapsed || expansion.shouldExpand
//    }
    
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: FolderView(currentFolder: folder)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                    ) {
                        Text(folder.title)
                    }
                }
            }
        }
    }
}

//struct FastVerCollapsibleFolder_Previews: PreviewProvider {
//    static var previews: some View {
//        FastVerCollapsibleFolder()
//    }
//}
