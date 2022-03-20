//
//  MemoEditView.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/20.
//

import SwiftUI

struct MemoEditView<PlusButton: View, Toolbar: View>: View {
        
    var plusView: PlusButton
    var toolbarView: Toolbar
    
    var body: some View {
        
        VStack {
            Spacer()
            ZStack {
                HStack {
                    Spacer()
                    VStack(spacing: Sizes.minimalSpacing) {
                        plusView
                    }
                }
                HStack {
                    Spacer()
                    toolbarView
                }
            }
        }
        
        
    }
}



struct SubFolderEditView<SubButton: View, SubFolder: View>: View {
    
    let subButton: SubButton
    let subFolderView: SubFolder
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    subButton
                        .padding(.trailing, Sizes.overallPadding )
                    
                    subFolderView
                } // end of ZStack
            }
            Spacer()
        }
        
        
    }
}
