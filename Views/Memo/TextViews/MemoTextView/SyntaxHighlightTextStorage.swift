/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.


// https://www.raywenderlich.com/5960-text-kit-tutorial-getting-started#


import UIKit

class SyntaxHighlightTextStorage: NSTextStorage {

    private var replacements: [String: [NSAttributedString.Key: Any]] = [:]
    
    let backingStore = NSMutableAttributedString()
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        print("replaceCharactersInRange: \(range) withString: \(str)")
        
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        print("setAttributes: \(String(describing: attrs)) range: \(range)")
        
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
//    func applyStylesToRange(searchRange: NSRange) {
//        // Create a bold and a normal font to format the text using font descriptors.
//        // Font descriptors help you avoid the use of hard-coded font strings to set font types and styles.
//        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
//        let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)
//        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: 0)
//        let normalFont = UIFont.preferredFont(forTextStyle: .body)
//
//        // Create a regular expression that locates any text surrounded by asterisks.
//        // For example, in the string “iOS 8 is *awesome* isn't it?”, the regular expression stored in regexStr above will match and return the text “*awesome*”.
//        let regexStr = "(\\*\\w+(\\s\\w+)*\\*)" // (\\*\\w+(\\s+\\w+)*\\*) – try it out!
//        let regex = try! NSRegularExpression(pattern: regexStr)
//        let boldAttributes = [NSAttributedString.Key.font: boldFont]
//        let normalAttributes = [NSAttributedString.Key.font: normalFont]
//        // Enumerate the matches returned by the regular expression and apply the bold attribute to each one.
//        regex.enumerateMatches(in: backingStore.string, range: searchRange) { match, flags, stop in
//            if let matchRange = match?.range(at: 1) {
//                addAttributes(boldAttributes, range: matchRange)
//                // Reset the text style of the character that follows the final asterisk in the matched string to "normal".
//                // This ensures that any text added after the closing asterisk is not rendered in bold type.
//
//                let maxRange = matchRange.location + matchRange.length
//                if maxRange + 1 < length {
//                    addAttributes(normalAttributes, range: NSMakeRange(maxRange, 1))
//                }
//            }
//        }
//    }
    
    func applyStylesToRange(searchRange: NSRange) {
      let normalAttrs =
        [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
      addAttributes(normalAttrs, range: searchRange)

      // iterate over each replacement
      for (pattern, attributes) in replacements {
        do {
          let regex = try NSRegularExpression(pattern: pattern)
          regex.enumerateMatches(in: backingStore.string, range: searchRange) {
            match, flags, stop in
            // apply the style
            if let matchRange = match?.range(at: 1) {
              print("Matched pattern: \(pattern)")
              addAttributes(attributes, range: matchRange)
                
              // reset the style to the original
              let maxRange = matchRange.location + matchRange.length
              if maxRange + 1 < length {
                addAttributes(normalAttrs, range: NSMakeRange(maxRange, 1))
              }
            }
          }
        }
        catch {
          print("An error occurred attempting to locate pattern: " +
                "\(error.localizedDescription)")
        }
      }
    }

    func performReplacementsForRange(changedRange: NSRange) {
        var extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(changedRange.location, 0)))
        
        extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(NSMaxRange(changedRange), 0)))
        applyStylesToRange(searchRange: extendedRange)
        
    }
    
    func createAttributesForFontStyle(
        _ style: UIFont.TextStyle,
        withTrait trait: UIFontDescriptor.SymbolicTraits) -> [NSAttributedString.Key: Any] {
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            let descriptorWithTrait = fontDescriptor.withSymbolicTraits(trait)
            // force UIFont to return a size that matches the user's current font size preferences.
            let font = UIFont(descriptor: descriptorWithTrait!, size: 0)

            return [.font: font]
        }
    
    func createHighlightPatterns() {
        let scriptFontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Zapfino"])
        
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let bodyFontSize = bodyFontDescriptor.fontAttributes[.size] as! NSNumber
        let scriptFont = UIFont(descriptor: scriptFontDescriptor, size: CGFloat(bodyFontSize.floatValue))
        
        let boldAttributes = createAttributesForFontStyle(.body, withTrait: .traitBold)
        let italicAttributes = createAttributesForFontStyle(.body, withTrait: .traitItalic)
        let strikeThroughAttributes =  [NSAttributedString.Key.strikethroughStyle: 1]
         let scriptAttributes = [NSAttributedString.Key.font: scriptFont]
         let redTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        
        replacements = [
//            "(\\*\\w+(\\s\\w+)*\\*)": boldAttributes,
//            "(_\\w+(\\s\\w+)*_)": italicAttributes,
//            "([0-9]+\\.)\\s": boldAttributes,
            "(-\\w+(\\s\\w+)*-)": strikeThroughAttributes,
            "(~\\w+(\\s\\w+)*~)": scriptAttributes,
            "\\s([A-Z]{2,})\\s": redTextAttributes
          ]
    }
    
    override init() {
        super.init()
        createHighlightPatterns()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func processEditing() {
        performReplacementsForRange(changedRange: editedRange)
        super.processEditing()
    }
    
    func update() {
      let bodyFont = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
      addAttributes(bodyFont, range: NSMakeRange(0, length))
        
      createHighlightPatterns()
      applyStylesToRange(searchRange: NSMakeRange(0, length))
    }

    
}

// 아.. 첫 줄을 자연스럽게 큰 폰트로 만들려면 Regular expression 을 공부해야하는구나..
//https://www.raywenderlich.com/5765-regular-expressions-tutorial-getting-started



//"This is the first line.\n This is the second line.".match(/^.*$/m)[0];
 //                                                          /^(.*)$/m
// ^ : begin of line
// .* : any char (.) , 0 or more times (*)
// $ : end of line
// m : multiline mode.    (acts like a \n too)
// [0]: get first position of array of results .
