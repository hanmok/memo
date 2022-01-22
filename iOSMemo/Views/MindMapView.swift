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

class ShowingMemoFolderVM: ObservableObject {
    @Published var folderToShow: Folder? = nil
    @Published var selectedMemo: Memo? = nil
}

struct MindMapView: View {
    
    let imageSize: CGFloat = 28
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @ObservedObject var expansion = ExpandingClass()
    @StateObject var showingMemoVM = ShowingMemoFolderVM()
    
    @State var showMemoList = false
    @State var showMemo = false
    
    @State private var shouldNavigate: Bool = false
    
    func spreadPressed() {
        expansion.shouldExpand.toggle()
        print("\(expansion.shouldExpand) has changed to \(expansion.shouldExpand)")
    }
    
    var body: some View {
        
        // vercollapsibleFolder 가 recursive 라서 Binding 넣기가 너무 애매한데 .. ??
        if showingMemoVM.folderToShow != nil {
            DispatchQueue.global().async {
                showMemoList = true
            }
        }
        
        if showingMemoVM.selectedMemo != nil {
            DispatchQueue.global().async {
                 showMemo = true
            }
        }
        
        return ZStack { NavigationView {
            
            if showingMemoVM.selectedMemo != nil {
                
                NavigationLink(destination: MemoViewForMindMap(
                    memo: showingMemoVM.selectedMemo!,
                    showMemo: $showMemo,
                    showMemoList: $showMemoList,
                    showingMemoVM: showingMemoVM),
                               isActive: $showMemo) {}
                
            }
            
            ScrollView(.vertical) {
                
                HStack {
                    VerCollapsibleFolder(folder: topFolders.first!)
                        .environmentObject(showingMemoVM)
                        .padding([.leading], Sizes.overallPadding)
                        .padding(.top, Sizes.overallPadding * 3)
                    Spacer()
                }
                .environmentObject(expansion)
            }
            .sheet(isPresented: $showMemoList, content: {
                ScrollView(.vertical) {
                    // makes fatal error
                    if showingMemoVM.folderToShow != nil {
                        MemoListForMindMapView(folder: showingMemoVM.folderToShow!, showMemo: $showMemo, showingMemoVM: showingMemoVM)
                    }
                }
                .padding(.top, 20)
            })
            
        }
            if !showMemo {
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Close")
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: spreadPressed) {
                            if expansion.shouldExpand {
                                //                            MinusImage()
                                ChangeableImage(imageSystemName: "arrow.down.right.and.arrow.up.left", width: 28, height:28)
                                    .padding()
                                
                            } else {
                                //                            PlusImage()
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
}

//struct MindMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MindMapView(homeFolder: deeperFolder)
//    }
//}
