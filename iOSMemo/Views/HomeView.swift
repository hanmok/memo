//
//  HomeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/06.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @EnvironmentObject var nav: NavigationStateManager
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    var body: some View {
            FolderView(
                currentFolder: nav.selectedFolder ?? Folder(title: "HomeFolder", context: context))
    } // how to make an initial Folder here ??
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

/*
 
HomeView()
    .environment(\.managedObjectContext, persistenceController.container.viewContext)
    .environmentObject(NavigationStateManager())

 */
