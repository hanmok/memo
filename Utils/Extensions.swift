//
//  Extensions.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import Foundation
import SwiftUI
import CoreData

extension Image {
    func setupAdditional(scheme: ColorScheme, size: CGFloat = 20) -> some View {
        self
            .addMode()
            .adjustTintColor(scheme: scheme)
            .frame(width: size , height: size)
    }
    
    func addMode(contentMode: ContentMode = .fit) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

extension View {
    
    // MARK: - TintColor
    func adjustTintColor(scheme: ColorScheme) -> some View {
        self
            .tint(scheme == .dark ? .white : .black)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape( RoundedCorner(radius: radius, corners: corners) )
        }
    
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
    
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension NSManagedObjectContext {
    func saveCoreData() { // save to coreData
        DispatchQueue.main.async {
            do {
                try self.save()
            } catch {
                print("error occurred druing saving to CoreData \(error)")
            }
        }
    }
}


struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}




extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}




//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//
//
//    }
//
//    func startEditing() {
//        sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
//    }
//}







//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape( RoundedCorner(radius: radius, corners: corners) )
//    }
//}
//
//struct RoundedCorner: Shape {
//
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}



extension UITextView {
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x:0, y:0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: LocalizedStringStorage.keyboardDone, style: .done, target: self, action: #selector(self.doneButtonAction))
//        done.tintColor = .buttonTextColor
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        DispatchQueue.main.async {
            self.resignFirstResponder()
        }
    }
}
