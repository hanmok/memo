//
//  TrashBinCell.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI

struct TrashBinCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    var body: some View {
        NavigationLink(destination: TrashFolderView()
                        .environmentObject(trashBinVM)
        ) {
            HStack {
                Text(LocalizedStringStorage.trashbin)
                    .foregroundColor(.red)
                Spacer()
                Text("\(trashBinVM.trashBinFolder.memos.count)")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(colorScheme == .dark ? Color(white: 0.1) : Color(white: 0.94))
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            
            Button {
                // DO NOTHING
            } label: {
                ChangeableImage(imageSystemName: "multiply")
            }
            .tint(.gray)
        }
    }
}
