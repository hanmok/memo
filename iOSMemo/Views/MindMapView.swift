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

struct MindMapView: View {
    
    let imageSize: CGFloat = 28
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    @ObservedObject var expansion = ExpandingClass()
    
    
    func spreadPressed() {
        expansion.shouldExpand.toggle()
        print("\(expansion.shouldExpand) has changed to \(expansion.shouldExpand)")
    }
    
    var body: some View {
        
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
