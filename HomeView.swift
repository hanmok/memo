//
//  HomeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/06.
//

import SwiftUI
import CoreData

struct HomeView: View { 
//    VStack(spacing:0) {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
    
    @EnvironmentObject var messageVM: MessageViewModel
    @AppStorage(AppStorageKeys.isFirstScreenSecondView) var isFirstScreenSecondView = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        return NavigationView {
            MindMapView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: topFolders.filter{ FolderType.compareName($0.title, with: .folder)}.first!,
                        archiveFolder: topFolders.filter{FolderType.compareName($0.title, with: .archive)}.first!
                    )
                ,isShowingSecondView: isFirstScreenSecondView
            )
                .environmentObject(TrashBinViewModel(trashBinFolder: topFolders.filter {
                    FolderType.compareName($0.title, with: .trashbin)}.first!))
        }
        .overlay {
            VStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? Color.init(white: 0.1) : Color.subColor)
                        .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.subColor)

                    VStack {
                    Text(messageVM.message)
                        .foregroundColor(.navBtnColor)
                        .padding(.top, 10)
                    Spacer()
                    }
                }
                .frame(height: UIScreen.hasSafeBottom ? 60 : 40)
                .offset(y: messageVM.shouldShow ? 0 : 100)
                .overlay(
                    VStack(spacing: 0) {
                        Rectangle().frame(width: UIScreen.screenWidth, height: 1, alignment: .top).foregroundColor(colorScheme == .dark ? .navBtnColor : .clear)
                    Spacer()
                    }
                )
                .offset(y: messageVM.shouldShow ? 0 : 100)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
