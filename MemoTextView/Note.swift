//
//  Note.swift
//  DeeepMemo (iOS)
//
//  Created by 이한목 on 2022/02/26.
//


import Foundation

class Note {
  var contents: String
  let timestamp: Date
  
  // an automatically generated note title, based on the first line of the note
  var title: String {
    // split into lines
    let lines = contents.components(separatedBy: CharacterSet.newlines)
    // return the first
    return lines[0]
  }
  
  init(text: String) {
    contents = text
    timestamp = Date()
  }
  
}
