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
  var beforeFirstNode: Bool
  
  init(beginNode: Deque<T>.Node<T>?) {
    current = beginNode
    beforeFirstNode = true
  }
  
  mutating func next() -> T? {
    if beforeFirstNode {
      beforeFirstNode = false
      return current?.content
    } else {
      guard current?.next != nil else { return nil }
      current = current?.next
      return current?.content
    }
  }
  
  mutating func previous() -> T? {
    if beforeFirstNode { return nil }
    guard current?.prev != nil else {
      beforeFirstNode = true
      return nil
    }
    current = current?.prev
    return current?.content
  }
  
  var content: T? {
    return current?.content
  }
}
