//
//  textFieldTestview.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/11.
//

import SwiftUI

struct textFieldTestview: View {
    
    @State var location: String = ""
    
    var body: some View {
        let binding = Binding<String>(get: {
            self.location
        }, set: {
            self.location = $0
            // do whatever you want here
        })
        return VStack {
            Text("Current location: \(location)")
            TextField("Search Location", text: binding)
        }
    }
}

struct textFieldTestview_Previews: PreviewProvider {
    static var previews: some View {
        textFieldTestview()
    }
}



