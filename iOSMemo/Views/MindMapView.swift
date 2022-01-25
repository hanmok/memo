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
    var isCollapsed: Bool = false
    var isShowing: Bool = true
}

struct LevelAndCollapsed {
    var level: Int
    var collapsed: Bool
}


class FastFolderWithLevelGroup: ObservableObject {
    @Published var allFolders: [FolderWithLevel]
    
    init(targetFolder: Folder) {
        self.allFolders = Folder.getHierarchicalFolders(topFolder: targetFolder)
    }
}

struct MindMapView: View {
    
    let imageSize: CGFloat = 28
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @StateObject var memoEditViewModel = MemoEditViewModel()
    
    @StateObject var expansion = ExpandingClass()
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    func spreadPressed() {
        expansion.shouldExpand.toggle()
        print("\(expansion.shouldExpand) has changed to \(expansion.shouldExpand)")
    }
    
    var body: some View {
        
//        let foldersWithLevel = getHierarchicalFolders(topFolder: topFolders.first!)
//        let foldersWithLevel = fastFolderWithLevelGroup.allFolders
//        var collapsedLevel = 1000
        
        // vercollapsibleFolder 가 recursive 라서 Binding 넣기가 너무 애매한데 .. ??
        
        
        return ZStack(alignment: .topLeading) {
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
                    
//                    Text("hello").swipeActions(edge: .leading, allowsFullSwipe: true) {
//                        Text("hi")
//                    }
                    
                    TestView()
                    
                    
                        List {
                            ForEach(1 ..< 18) { index in
                                Text("\(index)")
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Text("hi")
                                    }
                            }
                        }
                        Spacer()
                    
                    
                    
                    HStack {
                        VStack(alignment: .leading) {
                            
//                            List {
                                ForEach(fastFolderWithLevelGroup.allFolders, id: \.self) { folderwithlevel in
                                    
                                    HStack {
                                        ForEach(0..<folderwithlevel.level) { _ in
                                            Text(" ")
                                        }
                                        FastVerCollapsibleFolder(folder: folderwithlevel.folder)
                                            .environmentObject(memoEditViewModel)
                                        
                                    } // end of HStack
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, Sizes.smallSpacing)
                                    
                                    Rectangle()
                                        .frame(height: 0.5)
                                        .foregroundColor(Color(.sRGB, white: 1, opacity: 1))
                                        .padding(.horizontal, 10)

                                } // end of ForEach, means each Folder cell
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button(action: {print("to the left")}) {
                                        Text("1")
                                    }
                                }
//                            }
                        }
                        .padding(.vertical, 5)
                        .background(Color(.sRGB, white: 0.95, opacity: 1))
                        .cornerRadius(5)
                        .padding(.horizontal, Sizes.overallPadding)
                        .frame(width: UIScreen.screenWidth / 2)
                        
                        Spacer()
                    }
                
                } // end of scrollView
                .navigationBarHidden(true)
            //            }
            
            // spreading Button
//            HStack {
//                Spacer()
//                VStack {
//
//                    Spacer()
//
//                    Button(action: spreadPressed) {
//                        if expansion.shouldExpand {
//                            ChangeableImage(imageSystemName: "arrow.down.right.and.arrow.up.left", width: 28, height:28)
//                                .padding()
//
//                        } else {
//                            ChangeableImage(imageSystemName: "arrow.up.left.and.arrow.down.right", width: 28, height:28)
//                                .padding()
//                        }
//                    }
//                    .padding(20)
//                }
//            }
            
            
        }
    }
}
