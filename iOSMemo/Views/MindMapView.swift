//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

class ExpandingClass: ObservableObject {
    @Published var shouldExpand: Bool = false
}

//class ShowingMemoFolderVM: ObservableObject {
//    @Published var folderToShow: Folder? = nil
//    @Published var selectedMemo: Memo? = nil
//}

// 얘가 너무 무거워진 것 같기도 하고 ... 아니야. Ver 에 뭔가 문제가 있음.
// 같은 View 에서 Hor , Ver 을 펼쳤을 때 걸린 시간이 너무 차이가 나.
// 여기 다른 작업들도 넣어야하는데 ..;;;;; 어떻게 다 펼치지 ??
// 어떤 것들 때문에 이렇게 늦어지는걸까 ??

struct FolderWithLevel: Hashable {
    var folder: Folder
    var level: Int
}

//class FastFolderWithLevel: ObservableObject {
//    @Published var folder: Folder
//    @Published var level: Int
//
//    init(topFolder: Folder) {
//        self.folder = topFolder
//        self.level = 0
//    }
//}

class FastFolderWithLevelGroup: ObservableObject {
    
}

struct MindMapView: View {
    
    let imageSize: CGFloat = 28
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @StateObject var memoEditViewModel = MemoEditViewModel()
    
    @ObservedObject var expansion = ExpandingClass()
    
    
    func spreadPressed() {
        expansion.shouldExpand.toggle()
        print("\(expansion.shouldExpand) has changed to \(expansion.shouldExpand)")
    }
    
    func getHierarchicalFolders(topFolder: Folder) -> [FolderWithLevel] {
        var currentFolder: Folder? = topFolder
        var level = 0
        var trashSet = Set<Folder>()
        var folderWithLevelContainer = [FolderWithLevel(folder: currentFolder!, level: level)]
        var folderContainer = [currentFolder]
        
    whileLoop: while (currentFolder != nil) {
        print("currentFolder: \(currentFolder!.id)")

        if currentFolder!.subfolders.count != 0 {
            
            // check if trashSet has contained Folder of arrayContainer2
            for folder in currentFolder!.subfolders.sorted() {
                if !trashSet.contains(folder) && !folderContainer.contains(folder) {
    //            if !trashSet.contains(folder) && !arrayContainer2 {
                    currentFolder = folder
                    level += 1
                    folderContainer.append(currentFolder!)
                    folderWithLevelContainer.append(FolderWithLevel(folder: currentFolder!, level: level))
                    continue whileLoop // this one..
                }
            }
            // subFolders 가 모두 이미 고려된 경우.
            trashSet.update(with: currentFolder!)
            
            
        } else { // subfolder 가 Nil 인 경우
            
            trashSet.update(with: currentFolder!)
        }
        
        for i in 0 ..< folderWithLevelContainer.count {
            if !trashSet.contains(folderWithLevelContainer[folderWithLevelContainer.count - i - 1].folder) {
                
                currentFolder = folderWithLevelContainer[folderWithLevelContainer.count - i - 1].folder
                level = folderWithLevelContainer[folderWithLevelContainer.count - i - 1].level
                break
            }
        }
        
        if folderWithLevelContainer.count == trashSet.count {
            break whileLoop
        }
    }
        
        
        return folderWithLevelContainer
    }
    
    
    var body: some View {
        
        let foldersWithLevel = getHierarchicalFolders(topFolder: topFolders.first!)
        
        // vercollapsibleFolder 가 recursive 라서 Binding 넣기가 너무 애매한데 .. ??
        
        
        return ZStack {
//            NavigationView {
                ScrollView(.vertical) {
                    
                    HStack {
                        VerCollapsibleFolder(expansion: expansion, folder: topFolders.first!)
                            .padding(.leading, Sizes.overallPadding)
                            .padding(.top, Sizes.overallPadding * 3)
                        Spacer()
                        
                        
                    }
                    .environmentObject(expansion)
                    .environmentObject(memoEditViewModel)
                    
                    HStack {
                        VStack {
                            ForEach(foldersWithLevel, id: \.self) { folderwithlevel in
                                HStack {
                                    Text("\(folderwithlevel.level)")
                                    ForEach(0..<folderwithlevel.level) { _ in
                                        Text(" ")
                                    }
//                                    Text(folderwithlevel.folder.title)
                                    FastVerCollapsibleFolder(folder: folderwithlevel.folder)
                                        .environmentObject(memoEditViewModel)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                    
                } // end of scrollView
                .navigationBarHidden(true)
            //            }
            HStack {
                Spacer()
                VStack {
                    
                    Spacer()
                    
                    Button(action: spreadPressed) {
                        if expansion.shouldExpand {
                            ChangeableImage(imageSystemName: "arrow.down.right.and.arrow.up.left", width: 28, height:28)
                                .padding()
                            
                        } else {
                            ChangeableImage(imageSystemName: "arrow.up.left.and.arrow.down.right", width: 28, height:28)
                                .padding()
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
}
