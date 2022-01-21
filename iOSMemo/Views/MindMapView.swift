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

struct MindMapView: View {

    let imageSize: CGFloat = 28
//    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @ObservedObject var expansion = ExpandingClass()
    
    @Environment(\.presentationMode) var presentationMode
    

    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
    
    
    @State private var shouldNavigate: Bool = false
    
    func spreadPressed() {
        expansion.shouldExpand.toggle()
        print("\(expansion.shouldExpand) has changed to \(expansion.shouldExpand)")
    }
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            HorCollapsibleMind(expansion: expansion, folder: topFolders.first!, openFolder: { folder in
                
            })
                .environmentObject(expansion)
        }
        .overlay {
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

//struct MindMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MindMapView(homeFolder: deeperFolder)
//    }
//}
