//
//  SubFolderContainer.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI


struct SubFolderList: View {
    
    var folder: Folder
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func navigateToSubfolder() { }
    func showSubFolders(_ subfolder: Folder) -> some View {
        return Button(action: navigateToSubfolder) {
            Text(subfolder.title)
                .tint(colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, Sizes.smallSpacing)
        }.frame(height: 36)
    }
    
    var subfolders: [Folder]? {
        if let validSubFolders = folder.subFolders {
            return validSubFolders
        } else {
            return nil
        }
    }
    
    var memos: [Memo]? {
        if let validMemos = folder.memos {
            return validMemos
        } else {
            return nil
        }
    }
    var memoViewModels: [MemoViewModel]? {
        if let validMemos = folder.memos {
            var viewModels : [MemoViewModel] = []
            for eachMemo in validMemos {
                viewModels.append(MemoViewModel(memo: eachMemo))
            }
            return viewModels
        } else {
            return nil
        }
    }
    
    // Too Long to use ;;;
//    func convertModelToViewModel(memo: Memo) -> MemoViewModel {
//        return MemoViewModel(memo: memo)
//    }
    
    var body: some View {
        VStack {
            // List of Subfolders
            List {
                Section {
                    if subfolders != nil {
                        ForEach(subfolders!) { subfolder in
                            ZStack(alignment: .leading) {
                                NavigationLink(
                                    destination: FolderView(folder: subfolder)
                                ){
                                    EmptyView()
                                }
                                Text(subfolder.title)
                            }
                        }
                    }
                } footer: {
                    SubFolderToolBarView()
                }
            }
            
            
            
            // List of memos
            // Using 'List' here is not good idea..
            
            
            /*
            List {
                Section {
                    if memos != nil {
                        ForEach(memos!) { memo in
                            NavigationLink(destination: MemoView(mvm: MemoViewModel(memo: memo))) {

                                MemoBoxView(memo: memo)
                            }
                        }
                    }
                }
            }
            .background(.green)
            */
            
            
        }
//        .background(.secondary)
        
        
        /*
                VStack {
        //        ScrollView {
        //            NavigationView {
                    LazyVStack {
                        if folder.subFolders != nil {
                            ForEach(folder.subFolders!) { subfolder in
                                NavigationLink(destination: FolderView(folder: subfolder)) {
                                    Text(subfolder.title)
                                }
                            }
                        }
                    }
                    .background(.green)
        //        }
        //        .background(.blue)
        //            }
                    SubFolderToolBarView()
                }
        
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if folder.subFolders != nil {
                            ForEach(folder.subFolders!, id: \.self) {subfolder in
                                showSubFolders(subfolder)
                            }
                        } else {
                            Text("Add Subfolders")
                                .tint(colorScheme == .dark ? .white : .black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, Sizes.smallSpacing)
                                .frame(height: 36)
                        }
                    }
                }
                .background(.green)
        */
        
        
    }
}

//    .font(.title2)
//    .frame(maxWidth: .infinity, alignment: .leading)

struct SubFolderContainer_Previews: PreviewProvider {
    
    static var previews: some View {
        SubFolderList(folder: folder2)
    }
}
