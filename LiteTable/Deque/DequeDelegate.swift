//
//  DequeDelegate.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-14.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

protocol DequeDelegate: class {
  func headAdded(_ element: Any)
  func headRemoved(_ element: Any)
  func tailAdded(_ element: Any)
  func tailRemoved(_ element: Any)
}
