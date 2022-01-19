//
//  HomeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/06.
//

import SwiftUI
import CoreData

// received lists from DeeepMemoAPp
/*
 .environment(\.managedObjectContext, persistenceController.container.viewContext)
 .environmentObject(NavigationStateManager())
 */

struct HomeViewPrev: View { // top folder fetch
    // previously selected Folder
    @EnvironmentObject var nav: NavigationStateManager
    @State var testChange = false
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
//    @AppStorage("test") var test = ""
//    @AppStorage("initialFolder") var initialFolder = Folder(title: "", context: NSManagedObjectContext())
    
    
    // when app launched, set default folderview to home view.
    // if not exist, make one and use.
    
//    var initialFolder: Folder {
//
//        if nav.selectedFolder != nil {
//            return nav.selectedFolder!
//        }
//        // selectedFolder not exist.
//        let sampleFolder = Folder.returnSampleFolder(context: context)
//        nav.selectedFolder = sampleFolder
////        return folder
//        return sampleFolder
//    }
//
//    var subMemos: [Memo] {
//        var targetMemo = Set<Memo>()
//
//        if nav.selectedFolder != nil {
//            targetMemo = nav.selectedFolder!.memos
//
//        } else {
//            let folder = Folder.returnSampleFolder(context: context)
//            targetMemo = folder.memos
//        }
//
//        return convertSetToArray(set: targetMemo)
//    }
    
    
//    @ViewBuilder
    var body: some View {
        // 1. use nav.selectedFolder
        // 2. if not exist, set selectedFolder to topFolder
        // 3. if topFolder not exist, create topFolder and do 2.
//        FolderView(
//            currentFolder: initialFolder)
//        UnitTestHelpers.deletesAll(container: )
//        UnitTestHelpers.deletesAllMemos(context: context)
        
        //
//        UnitTestHelpers.deletesAllFolders(context: context)
        
        if nav.selectedFolder == nil  {
            if topFolders.count != 0 {
                nav.selectedFolder = topFolders.first!
            } else {
                // production
                // nav.selectedFolder = Folder.createHomeFolder(context: context)
                // test
                nav.selectedFolder = Folder.returnSampleFolder(context: context)
            }
        }
        // original
        return NavigationView {
            FolderView(currentFolder: nav.selectedFolder!)
                .navigationBarTitle(nav.selectedFolder!.title)
                .navigationBarItems(trailing:Button(action: {
                    print("subfolder Info: \n \(nav.selectedFolder!.subfolders)")
                    print("memos Info: \n \(nav.selectedFolder!.memos)")
                }, label: {
                    ChangeableImage(imageSystemName: "magnifyingglass")
                }))
                .onAppear {
                    nav.selectedFolder!.getFolderInfo()
                }
        }
        
//        return MindMapView(homeFolder: nav.selectedFolder!)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

