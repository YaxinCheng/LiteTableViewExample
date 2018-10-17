//
//  LiteTableDelegate.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

public protocol LiteTableDelegate: class {
  func cellReuseThreshold(_ tableView: LiteTableView) -> Int
}

public protocol LiteTableDataSource: class {
  func numberOfCells(_ tableView: LiteTableView) -> Int
  func cellHeight(_ tableView: LiteTableView) -> CGFloat
  func prepareCell(_ tableView: LiteTableView, at index: Int) -> LiteTableCell
}
