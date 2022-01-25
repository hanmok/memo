//
//  HorCollapsibleMind.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/03.
//

import SwiftUI
import CoreData

// do i need a closure here ?

struct HorCollapsibleMind: View, FolderNode {
    // navigation은, 밖에서 (으로) 전달해주어야 할 것 같은데 ??
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
//    @EnvironmentObject var folderVM: FolderViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel

    @ObservedObject var expansion: ExpandingClass
    
    var folder: Folder
    
    var openFolder: (Folder) -> Void = { _ in }
    
    
    @State private var collapsed: Bool = true
    /// level of Depth
    
    private let collapsedLevel: Int = 0
    
    var subfolders: [Folder] {
        var folders: [Folder] = []
        for eachFolder in folder.subfolders {
            folders.append(eachFolder)
        }
        return folders
    }
    
    var shouldExpandOverall: Bool {
        return !collapsed || expansion.shouldExpand
    }
    
    func moveToFolderView() {
    }
    
    func toggleCollapsed() {
        self.collapsed.toggle()
        if self.expansion.shouldExpand {
            self.expansion.shouldExpand = false
        }
    }
    
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0{
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: toggleCollapsed) {
                HStack {
                    Text(folder.title)
                    
                } // end of HStack
                .adjustTintColor(scheme: colorScheme)
                
            } // end of Button
            .padding(.leading, Sizes.overallPadding)
            
            .contextMenu {
                VStack {
                    // NEW NAVIGATION
                    Button(action: {
                        folderEditVM.navigationTargetFolder = folder
//                         dismiss current View
//                        navigationLink , navigate to navigationTarget
                    }) {
                        HStack {
                            Text("open")
                        }
                    }
                    // RENAME
                    Button(action: {
                        //TODO : present TextField
                    }) {
                        Text("rename")
                    }
                    // REMOVE
                    Button(action: {
                        Folder.delete(folder)
                        context.saveCoreData()
                    }) {
                        Text("remove")
                    }
                    // CUT
                    Button(action: {
                        folderEditVM.didCutFolders.append(folder)
                    }) {
                        Text("cut")
                    }
                    //PASTE HERE !
                    Button(action: {
                        
                        for each in folderEditVM.didCutFolders {
                            each.parent = nil
                        }
                        
                        for each in folderEditVM.didCutFolders {
                            folder.add(subfolder: each)
                        }
                        // 하나의 folder 에 있을수만 있나.. ??
                        // copy action 을 하나 만들어봐야겠는데 ?

                        context.saveCoreData()
                        
                        folderEditVM.didCutFolders = []
                        
                    }) {
                        Text("paste folders here")
                    }
                    
                    Button(action: {
                        
                        for each in memoEditVM.didCutMemos {
//                            folder.add(subfolder: each)
                            folder.add(memo: each)
                        }
                        
                        // 하나의 folder 에 있을수만 있나.. ??
                        // copy acti$on 을 하나 만들어봐야겠는데 ?

                        context.saveCoreData()
                        
//                        folderEditVM.didCutFolders = []
                        memoEditVM.didCutMemos = []
                    }) {
                        Text("paste folders here")
                    }
                }
            }
            
            
            if folder.subfolders.count != 0 && shouldExpandOverall {
                VStack(spacing: 0) {
                    ForEach(subfolders) {subfolder in
                        
                        HorCollapsibleMind(expansion: expansion, folder: subfolder)
                        
                            .padding(.bottom, 10)
                    }
                }
                .animation(.easeOut, value: shouldExpandOverall)
                .transition(.slide)
            } // end of second Element in VStack (HStack)
            
            Spacer()
        }
        .onAppear {
            if expansion.shouldExpand {
                collapsed = false
            }
        }
    }
}


//struct HorCollapsibleMind_Previews: PreviewProvider {
//    static var previews: some View {
//        HorCollapsibleMind(folder: deeperFolder)
//    }
//}
