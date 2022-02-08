//
//  SubFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/27.
//

import SwiftUI
import CoreData
struct SubFolderView: View {
    
    //    @EnvironmentObject var folder: Folder
//    @Environment(\.managedObjectContext) var context
    @ObservedObject var folder: Folder
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    @Binding var isShowingSubFolderView: Bool
    @Binding var isAddingFolder: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let subFolders = folder.subfolders.sorted{ $0.title < $1.title}
        
        return VStack(alignment: .leading) {
            
            // Back Button and Adding SubFolder Button
            
            HStack {
                Button {
                    // dismiss
                    isShowingSubFolderView = false
                } label: {
                    ChangeableImage(imageSystemName: "arrow.right")
                }
                .padding(.leading, 12)
                
                Spacer()
                
                Button {
                    isAddingFolder = true
                } label: {
                    ChangeableImage(imageSystemName: "folder.badge.plus", width: 28, height: 28)
                    
                }
                .padding(.trailing, 12)
            }
            .padding(.vertical, Sizes.smallSpacing)
            
            
            
            VStack(alignment: .leading, spacing: 5) {
                // testing
                
                
                ForEach(subFolders) { subFolder in
                    // how to make.. it disappear if moved ?
                    NavigationLink {
                        FolderView(currentFolder: subFolder)
                            .environmentObject(folderEditVM)
                            .environmentObject(memoEditVM)
                            .environmentObject(memoOrder)
                    } label: {
                        Text(subFolder.title)
                            .frame(alignment: .leading)
                    }
                    // What makes a subfolder go back to parent Folder ?
                    .simultaneousGesture(TapGesture().onEnded{
                        // hide SubFolderView when navigate
                        isShowingSubFolderView = false
                        memoEditVM.selectedMemos.removeAll()
                        memoEditVM.initSelectedMemos()
                    })

                } // end of ForEach
            } // end of VStack
            .padding(.leading, 12)
            
            if subFolders.count == 0 {
               
                Button {
                    isAddingFolder = true
                } label: {
                    Text("Press to Add")
                }
                .padding(.leading, 12)
            }
            Spacer()
        }
        .frame(width: UIScreen.screenWidth / 2.5)
            .background(Color.subColor)
        
            .cornerRadius(10)
        
    }
}

//struct SubFolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubFolderView()
//    }
//}
