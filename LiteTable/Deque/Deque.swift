//
//  Deque.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

struct Deque<T>: Sequence {
  
  weak var delegate: DequeDelegate?
  
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
  
  init(_ delegate: DequeDelegate? = nil) {
    self.delegate = delegate
  }
  
  mutating func appendHead(_ value: T) {
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
  
  mutating func appendTail(_ value: T) {
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
  
  private mutating func removeHeadAsync() {
    guard head != nil else { return }
    let next = head?.next
    head?.next = nil
    head = next
    count -= 1
  }
  
  mutating func removeHead() {
    semaphore.wait()
    removeHeadAsync()
    semaphore.signal()
  }
  
  private mutating func removeTailAsync() {
    if tail == nil {
      head = nil
    } else {
      if tail === head {
        tail = nil
        head = nil
      } else {
        let prev = tail?.prev
        tail?.next = nil
        prev?.next = nil
        tail = prev
      }
    }
    count -= 1
  }
  
  mutating func removeTail() {
    semaphore.wait()
    removeTailAsync()
    semaphore.signal()
  }
  
  mutating func removeAll() {
    semaphore.wait()
    for _ in 0 ..< count {
      removeHeadAsync()
    }
    semaphore.signal()
  }
}
