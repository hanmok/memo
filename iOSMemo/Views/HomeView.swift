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

struct HomeView: View { // top folder fetch
    // previously selected Folder
    @EnvironmentObject var nav: NavigationStateManager
    @State var testChange = false
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var folders: FetchedResults<Folder>
    // when app launched, set default folderview to home view.
    // if not exist, make one and use.
    
    
//    var initialFolder: Folder {
//        if nav.selectedFolder != nil {
//
//            if folders.count != 0 {
//                nav.selectedFolder = folders.first!
//                return nav.selectedFolder!
//            }
//        }
//        let homeFolder = Folder.createHomeFolder(context: context)
//        nav.selectedFolder = homeFolder
//        return homeFolder
//    }
    
    var initialFolder: Folder {
        
        if nav.selectedFolder != nil {
            return nav.selectedFolder!
            
        }
        
        let folder = Folder.returnSampleFolder(context: context)
//        let initialOne = folder.subfolders.first!
        let initialOne = folder
        nav.selectedFolder = initialOne
//        return folder
        return initialOne
    }
    
    var subMemos: [Memo] {
        var targetMemo = Set<Memo>()
        
        if nav.selectedFolder != nil {
            targetMemo = nav.selectedFolder!.memos
        } else {
            
            let folder = Folder.returnSampleFolder(context: context)
            targetMemo = folder.memos
        }
        
        return convertSetToArray(set: targetMemo)
    }
    
    
    
    var body: some View {
            FolderView(
                currentFolder: initialFolder)
        
        
        // NavigationTest
//        NavigationView {
//            VStack {
//                ForEach(subMemos, id: \.self) { memo in
//                    NavigationLink(destination: MemoView(memo: memo, parent: memo.folder!)) {
//                        Text(memo.title)
//                    }
//                }
//            }
//        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

/*
 
 HomeView()
 .environment(\.managedObjectContext, persistenceController.container.viewContext)
 .environmentObject(NavigationStateManager())
 
 */


func convertSetToArray<V: Comparable>(set: Set<V>) -> [V] {
    var initialArr: [V] = []
    for each in set {
        initialArr.append(each)
    }
    initialArr.sort()
    return initialArr
}
