//
//  LiteTableCell.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

public class LiteTableCell: NSViewController {
  
  deinit {
    view.removeFromSuperview()
  }
  
  private(set) var highlighted: Bool = false
  
  func highlightToggle() {
    highlighted = !highlighted
    let colour: NSColor = highlighted ? .controlAccentColor : .clear
    view.layer?.backgroundColor = colour.cgColor
  }
}
