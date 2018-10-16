//
//  Deque.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

struct Deque<T>: Sequence {
  func makeIterator() -> Deque<T>.Iterator {
    return Iterator(beginNode: head)
  }
  
  final class Node<T>: CustomStringConvertible {
    let content: T
    var next: Node<T>? = nil
    weak var prev: Node<T>? = nil
    
    init(_ content: T) {
      self.content = content
    }
    
    var description: String {
      return "\(content)"
    }
  }
  
  private var head: Node<T>? = nil
  private weak var tail: Node<T>? = nil
  var first: Node<T>? { return head }
  var last: Node<T>? { return tail }
  private let semaphore = DispatchSemaphore(value: 1)
  var count: Int = 0
  typealias Iterator = DequeIterator<T>
  var isEmpty: Bool {
    return count == 0
  }
  
  mutating func appendFirst(_ value: T) {
    semaphore.wait()
    let node = Node(value)
    if head != nil {
      node.next = head
      head?.prev = node
      head = node
    } else {
      head = node
      tail = node
    }
    count += 1
    semaphore.signal()
  }
  
  mutating func appendLast(_ value: T) {
    semaphore.wait()
    let node = Node(value)
    if tail != nil {
      tail?.next = node
      node.prev = tail
      tail = node
    } else {
      head = node
      tail = node
    }
    count += 1
    semaphore.signal()
  }
  
  private mutating func removeFirstAsync() -> T? {
    guard head != nil else { return nil }
    let next = head?.next
    head?.next = nil
    let value = head?.content
    head = next
    count -= 1
    return value
  }
  
  mutating func removeFirst() -> T? {
    semaphore.wait()
    let value = removeFirstAsync()
    semaphore.signal()
    return value
  }
  
  private mutating func removeLastAsync() -> T? {
    let value: T?
    if tail == nil {
      head = nil
      value = nil
    } else {
      if tail === head {
        value = tail?.content
        tail = nil
        head = nil
      } else {
        let prev = tail?.prev
        value = tail?.content
        tail?.next = nil
        prev?.next = nil
        tail = prev
      }
    }
    count -= 1
    return value
  }
  
  mutating func removeLast() -> T? {
    semaphore.wait()
    let value = removeLastAsync()
    semaphore.signal()
    return value
  }
  
  mutating func removeAll() {
    semaphore.wait()
    for _ in 0 ..< count {
      _ = removeFirstAsync()
    }
    semaphore.signal()
  }
}
