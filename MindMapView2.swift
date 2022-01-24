//
//  MindMapView2.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

//class ExpandingClass: ObservableObject {
//    @Published var shouldExpand: Bool = false
//}
//
//class ShowingMemoFolderVM: ObservableObject {
//    @Published var folderToShow: Folder? = nil
//    @Published var selectedMemo: Memo? = nil
//}

// 얘가 너무 무거워진 것 같기도 하고 ... 아니야. Ver 에 뭔가 문제가 있음.
// 같은 View 에서 Hor , Ver 을 펼쳤을 때 걸린 시간이 너무 차이가 나.
// 여기 다른 작업들도 넣어야하는데 ..;;;;; 어떻게 다 펼치지 ??
// 어떤 것들 때문에 이렇게 늦어지는걸까 ??

struct MindMapView2: View {
    
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
    
    @ViewBuilder
    var body: some View {
        
        // vercollapsibleFolder 가 recursive 라서 Binding 넣기가 너무 애매한데 .. ??
        
        var currentFolder = topFolders.first!
        
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
                
                VStack {
//                    while(currentFolder != nil ) {
                        VerCollapsibleFolderNode(expansion: expansion, folder: topFolders.first!)
                            .environmentObject(showingMemoVM)
                            .padding(.leading, Sizes.overallPadding)
                            .padding(.top, Sizes.overallPadding * 3)
                        
                        Spacer()
//                    }
                }
                .environmentObject(expansion)
                
                
                
                
            }
            .navigationBarHidden(true)
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
                        .background(.green)
                        
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

//struct MindMapView2_Previews: PreviewProvider {
//    static var previews: some View {
//        MindMapView2(homeFolder: deeperFolder)
//    }
//}


