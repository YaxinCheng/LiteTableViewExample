//
//  LiteTableDelegate.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

public protocol LiteTableDelegate: class {
  
}

public protocol LiteTableDataSource: class {
  var cellHeight: CGFloat { get }
  func prepareCell(at index: Int) -> LiteTableCell
}
