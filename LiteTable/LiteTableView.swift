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
  private var displayDeque: Deque<LiteTableCell>!
  
  public func reload() {
    let height = frame.height
    guard
      let cellHeight = liteDataSource?.cellHeight
    else { return }
    let availableRoom = 2 + Int(ceil(height / cellHeight)) + 2
    displayDeque = Deque(limit: availableRoom)
    for i in 0 ..< availableRoom {
      guard let cell = liteDataSource?.prepareCell(at: i) else { return }
      displayDeque.appendTail(cell)
    }
  }
}
