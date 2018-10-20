//
//  LiteTableCell.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

public class LiteTableCell: NSCollectionViewItem {
  
  deinit {
    view.removeFromSuperview()
  }
  
  private(set) var highlighted: Bool = false
  var highlightedColour: NSColor {
    if #available(OSX 10.14, *) {
      return .controlAccentColor
    } else {
      return .blue
    }
  }
  
  func highlightToggle() {
    highlighted = !highlighted
    let colour: NSColor = highlighted ? highlightedColour : .clear
    view.layer?.backgroundColor = colour.cgColor
  }
}
