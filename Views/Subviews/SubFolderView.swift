//
//  SubFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/27.
//

import SwiftUI
import CoreData
struct SubFolderView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var folder: Folder

    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder

    @Binding var isShowingSubFolderView: Bool
    @Binding var isAddingFolder: Bool
    
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
            
                ForEach(subFolders) { subFolder in

                    NavigationLink {
                        FolderView(currentFolder: subFolder)
                            .environmentObject(folderEditVM)
                            .environmentObject(memoEditVM)
                            .environmentObject(memoOrder)
                    } label: {
                        Text(subFolder.title)
                            .frame(alignment: .leading)
                            .lineLimit(1)
                            .adjustTintColor(scheme: colorScheme)
                    }

                    .simultaneousGesture(TapGesture().onEnded{
                        // hide SubFolderView when navigate
                        isShowingSubFolderView = false
                        memoEditVM.selectedMemos.removeAll()
                        memoEditVM.initSelectedMemos()
                    })
                } // end of ForEach
                // 왜.. 빈공간이 생깁니까??
            } // end of VStack
            .padding(.leading, 12)
            .padding(.bottom, subFolders.count == 0 ? 0 : 10)
//            .padding(.bottom, 10)
            
            if subFolders.count == 0 {
               
                Button {
                    isAddingFolder = true
                } label: {
                    Text("Press to Add")
                        .adjustTintColor(scheme: colorScheme)
                }
                .padding(.leading, 12)
                .padding(.bottom, 10)
            }

        }
        .frame(width: UIScreen.screenWidth / 2.5)
        .background(Color.weekSubColor)
        .background(
            colorScheme.adjustMainColors()
        )
            .cornerRadius(10)
    }
}

