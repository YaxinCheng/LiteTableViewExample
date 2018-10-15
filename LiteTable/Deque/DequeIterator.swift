//
//  DequeIterator.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

struct DequeIterator<T>: IteratorProtocol {
  typealias Element = T
  private var current: Deque<T>.Node<T>?
  
  init(beginNode: Deque<T>.Node<T>?) {
    current = beginNode
  }
  
  mutating func next() -> T? {
    let node = current
    current = current?.next
    return node?.content
  }
}
