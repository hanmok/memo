//
//  MainTabView.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/05/25.
//

import Foundation
import SwiftUI
import CoreData

struct MainTabView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
    
    @EnvironmentObject var messageVM: MessageViewModel
    @AppStorage(AppStorageKeys.isFirstScreenSecondView) var isFirstScreenSecondView = false
    @Environment(\.colorScheme) var colorScheme
    
    @State var tabSelection: Tabs = .memoList
    
    var customImage: Image {
        return SystemImage("rectangle.split.3x1")
            .rotationEffect(.degrees(90))
            .scaleEffect(CGSize(width: 1, height: 0.8)) as! Image
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection) {
                FirstTabView(fastFolderWithLevelGroup: FastFolderWithLevelGroup(
                    homeFolder: topFolders.filter{ FolderType.compareName($0.title, with: .folder)}.first!, // found nil here .. Why... ??
                    archiveFolder: topFolders.filter{FolderType.compareName($0.title, with: .archive)}.first!
                ), currentFolder: topFolders.filter { FolderType.compareName($0.title, with: .folder)}.first!)
                // Hide navigationBar
//                .hiddenNavigationBarStyle()
                .navigationBarHidden(true)
                .tabItem {
                    Label {
                        Text("Memo List")
                    } icon: {
                        Image(systemName: "rectangle.split.3x1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(90))
                    }
                }
                .tag(Tabs.memoList)
                SecondTabView(fastFolderWithLevelGroup: FastFolderWithLevelGroup(
                    homeFolder: topFolders.filter{ FolderType.compareName($0.title, with: .folder)}.first!, // found nil here .. Why... ??
                    archiveFolder: topFolders.filter{FolderType.compareName($0.title, with: .archive)}.first!
                ))
                .navigationBarHidden(true)
                .tabItem {
                    Label("Folder List", systemImage: "folder")
                }
                .tag(Tabs.folderList)
            }
            .environmentObject(TrashBinViewModel(trashBinFolder: topFolders.filter {
                FolderType.compareName($0.title, with: .trashbin)}.first!))
            
        }
        .navigationBarHidden(true)
        .overlay {
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(colorScheme == .dark ? Color.init(white: 0.1) : .white)
                        .background(colorScheme == .dark ? Color.init(white: 0.1) : .white)
                    
                    VStack {
                        Text(messageVM.message)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(.top, 10)
                        Spacer()
                    }
                }
                .cornerRadius(10)
                .frame(height: UIScreen.hasSafeBottom ? 70 : 50)
                .cornerRadius(10)
                .offset(y: messageVM.shouldShow ? 0 : 100)
                .overlay(
                    VStack(spacing: 0) {
                        Rectangle().frame(
                            width: UIScreen.screenWidth,
                            height: 1,
                            alignment: .top)
                        .cornerRadius(10)
                        .foregroundColor(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.85))
                        Spacer()
                    }
                )
                .offset(y: messageVM.shouldShow ? 0 : 100)
            }
        }
    }
    
    enum Tabs {
        case memoList
        case folderList
        case todos
        case settings
    }
}
