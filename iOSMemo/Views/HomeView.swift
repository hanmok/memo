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
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    // when app launched, set default folderview to home view.
    // if not exist, make one and use.
    var initialFolder: Folder {
        if nav.selectedFolder != nil {
            let parentFetch = Folder.topFolderFetch()
            // if exists, only one will be fetched
            if let parent = try? context.fetch(parentFetch) {
                if parent.count != 0 {
                    nav.selectedFolder = parent.first!
                    return nav.selectedFolder!
                }
            }
        }
        let homeFolder = Folder.createHomeFolder(context: context)
        nav.selectedFolder = homeFolder
    }
    
    var body: some View {
            FolderView(
                currentFolder: initialFolder)
    } // how to make an initial Folder here ??
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
