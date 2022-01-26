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
    
    @ObservedObject var folder: Folder
    
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                
                NavigationLink(destination: FolderView(currentFolder: folder)
                                .environmentObject(memoEditVM)
                                .environmentObject(folderEditVM)
                ) {
                    HStack {
                        Text(folder.title)
                                .foregroundColor(colorScheme.adjustTint())
                            
                            if folder.isFavorite {
                                Text(Image(systemName: "star.fill"))
                                    .tint(.yellow)
                            }
                        }
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background(.black)
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
