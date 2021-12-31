//
//  CollapsibleView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct CollapsibleView: View {
    var body: some View {
        Collapsible(label: "hi") {
            ScrollView
            {
                LazyVStack {
                    VStack {
                        Text("Testing1")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing11")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing21")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing31")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing41")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                }
            }
        }
    }
}

import SwiftUI

enum Orientation {
    case left
    case right
}

struct Collapsible<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var orientation: Orientation = .right
//    var eachHeight: CGFloat = 20
    @State var label: String
    @State var content: () -> Content
    
    @State private var collapsed: Bool = true
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Button(
                    action: { self.collapsed.toggle() },
                    label: {
                        HStack {
                            Text(self.label)
                            Spacer()
                            ChangeableImage(colorScheme: _colorScheme, imageSystemName: self.collapsed ? "chevron.down" : "chevron.up")
                            
                        }
                        .frame(height: 20)
                        .padding(.bottom, 1)
                        .background(Color.white.opacity(0.01))
                    } // end of label
                )
                    .buttonStyle(PlainButtonStyle())
                // what about scrolling.. ??? 'content' may contain
                self.content()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : 90)
                    .animation(.easeOut, value: collapsed)
                    .transition(.slide)
            }
        }
    }
}

/*
if orientation == .right { // place chevron on the right
    Text(self.label)
    Spacer()
    ChangeableImage(colorScheme: _colorScheme, imageSystemName: self.collapsed ? "chevron.down" : "chevron.up")
} else { // place chevron on the left
    ChangeableImage(colorScheme: _colorScheme, imageSystemName: self.collapsed ? "chevron.down" : "chevron.up")
    Spacer()
    Text(self.label)
}
*/

struct TestView: View {
    var body: some View {
        Collapsible(label: "Hi") {
            ScrollView {
                LazyVStack {
                    VStack {
                        Text("Testing1")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing11")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing21")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing31")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing41")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                }}
        }
    }
}

struct CollapsibleView_Previews: PreviewProvider {
    static var previews: some View {
        CollapsibleView()
    }
}
