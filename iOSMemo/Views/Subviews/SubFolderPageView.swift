//
//  SUbFolderPageView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/07.
//

import SwiftUI

struct SubFolderPageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
//    @ObservedObject var folder: Folder
    @EnvironmentObject var currentFolder: Folder
    @Binding var shouldAddSubFolder: Bool
    
    var subfolders: [Folder] {
        let sortedOldFolders = currentFolder.subfolders.sorted()
        
        return sortedOldFolders
    }
    
    var body: some View {
        // MARK: - SubFolder List
        VStack(spacing: 0) {
            HStack {
                Spacer()
                SubFoldersToolView(shouldAddSubfolder: $shouldAddSubFolder)
//                Color(.white)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(subfolders) { subfolder in
                        
                        NavigationLink(
                            destination: FolderView(currentFolder: subfolder)) {
                                FolderLabelView(folder: subfolder)
                                    .frame(width:50, height: 50)
                            }
                            .onAppear(perform: {
                                print("title of subFolder: \(subfolder.title)")
                            })
                            .onTapGesture {
                                print("tapped !! \(subfolder.title)")
                            }
                        
                            .padding(.horizontal, Sizes.overallPadding)
                            .padding(.top, Sizes.minimalSpacing * 4)
                    }
                }
                .padding(.bottom, 10)
//                }
            }
            //            }
        }
        // scroll to the right when subfolder added
        //        .onReceive(folder, perform: <#T##(Publisher.Output) -> Void#>)
        
        //        .background(Color.blue)
        // Tool bar on the top
        //        .overlay {
        //            HStack {
        //                Spacer()
        //                VStack {
        //                    SubFoldersToolView()
        //                    Spacer()
        //                }
        //            }
        ////            .background(.yellow)
        //        }
    }
}


struct SubFolderPageView_Previews: PreviewProvider {

    static var testFolder  = Folder(title: "test Folder", context: PersistenceController.preview.container.viewContext)

    static var previews: some View {
//        SubFolderPageView(folder: testFolder)
        SubFolderPageView( shouldAddSubFolder: .constant(false))
            .environmentObject(testFolder)
    }
}

