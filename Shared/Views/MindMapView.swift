//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

class ExpandingClass: ObservableObject {
    @Published var shouldExpand: Bool = false
}

struct MindMapView: View {
//    @ObservableObject var expansion : ExpandingClass
    @ObservedObject var expansion = ExpandingClass()
    var homeFolder: Folder
    @State private var shouldNavigate: Bool = false
    
    func spreadPressed() {
        expansion.shouldExpand.toggle()
        print("\(expansion.shouldExpand) has changed to \(expansion.shouldExpand)")
    }
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
//            HorCollapsibleMind(expansion: expansion, folder: homeFolder)
            HorCollapsibleMind(expansion: expansion, folder: homeFolder)
                .environmentObject(expansion)
        }
        .overlay {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action: spreadPressed) {
                        if expansion.shouldExpand {
                            MinusImage()
                        } else {
                            PlusImage()
                        }
                    }
                    .padding(20)

                }
            }

        }
    }
}

//struct MindMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MindMapView(homeFolder: deeperFolder)
//    }
//}
