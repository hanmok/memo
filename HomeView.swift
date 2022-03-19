//
//  HomeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/06.
//

import SwiftUI
import CoreData

struct HomeView: View { // top folder fetch
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
    
    
    var body: some View {
        
        return NavigationView {
            MindMapView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: topFolders.filter{ FolderType.compareName($0.title, with: .folder)}.first!,
                        archiveFolder: topFolders.filter{FolderType.compareName($0.title, with: .archive)}.first!
                    )
            )
                .environmentObject(TrashBinViewModel(trashBinFolder: topFolders.filter {
                    FolderType.compareName($0.title, with: .trashbin)}.first!))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
} 



