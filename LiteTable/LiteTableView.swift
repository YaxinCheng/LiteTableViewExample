//
//  LiteTableView.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

public class LiteTableView: NSStackView {
  public weak var liteDelegate: LiteTableDelegate?
  public weak var liteDataSource: LiteTableDataSource?
  private var displayDeque: Deque<LiteTableCell>
  private let extraSupplyment = 4
  
  enum Position {
    case top
    case bottom
  }
  
  public required init?(coder decoder: NSCoder) {
    displayDeque = Deque<LiteTableCell>()
    
    super.init(coder: decoder)
    displayDeque.delegate = self
  }
  
  public func reload() {
    if displayDeque.count > 0 { displayDeque.removeAll() }
    let threshold = liteDelegate?.reuseThreshold ?? -extraSupplyment
    let itemCount = liteDataSource?.itemCount ?? 0
    for index in 0 ..< min(threshold + extraSupplyment, itemCount) {
      guard let cell = liteDataSource?.prepareCell(at: index) else { break }
      displayDeque.appendTail(cell)
    }
  }
}

extension LiteTableView: DequeDelegate {
  func headAdded(_ element: Any) {
    addView((element as! LiteTableCell).view, in: .top)
  }
  
  func headRemoved(_ element: Any) {
//    Should be removed from superview automatically
  }
  
  func tailAdded(_ element: Any) {
    addView((element as! LiteTableCell).view, in: .bottom)
  }
  
  func tailRemoved(_ element: Any) {
//    Should be removed from superview automatically
  }
}
