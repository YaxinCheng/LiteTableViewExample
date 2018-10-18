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
  private var displayDeque: Deque<LiteTableCell> = []
  private var registeredNibs: [NSUserInterfaceItemIdentifier: NSNib] = [:]
  private var registeredClasses: [NSUserInterfaceItemIdentifier: LiteTableCell.Type] = [:]
  private var reuseQueues: [NSUserInterfaceItemIdentifier: Deque<LiteTableCell>] = [:]
  private var keyboardMonitor: Any?
  private(set) var highlightedCell: LiteTableCell?
  private lazy var currentCell: Deque<LiteTableCell>.Iterator = {
    return displayDeque.makeIterator()
  }()
  private var currentIndex: Int = -1
  public var allowedKeyCodes: Set<UInt16> = [125, 126]
  
  public required init?(coder decoder: NSCoder) {
    super.init(coder: decoder)
    setUp()
  }
  
  public override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setUp()
  }
  
  private func setUp() {
    distribution = .fill
    spacing = 0
    orientation = .vertical
    alignment = .centerX
    keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] in
      self?.keyUp(with: $0)
      return $0
    }
  }
  
  deinit {
    guard keyboardMonitor != nil else { return }
    NSEvent.removeMonitor(keyboardMonitor!)
    keyboardMonitor = nil
  }
  
  public func reload() {
    if displayDeque.count > 0 { displayDeque.removeAll() }
    let threshold = liteDataSource?.cellReuseThreshold(self) ?? 0
    let itemCount = liteDataSource?.numberOfCells(self) ?? 0
    for index in 0 ..< min(threshold, itemCount) {
      guard let cell = liteDataSource?.prepareCell(self, at: index) else { break }
      displayDeque.appendLast(cell)
      addView(cell.view, in: .top)
    }
  }
  
  public func register(nib: NSNib, withIdentifier identifier: NSUserInterfaceItemIdentifier) {
    registeredNibs[identifier] = nib
  }
  
  public func register(class: LiteTableCell.Type, withIdentifier identifier: NSUserInterfaceItemIdentifier) {
    registeredClasses[identifier] = `class`
  }
  
  public override func keyUp(with event: NSEvent) {
    switch event.keyCode {
    case 125: moveDown()// down
    case 126: moveUp() // up key
    default: super.keyUp(with: event)
    }
    if let cell = highlightedCell,
      allowedKeyCodes.contains(event.keyCode) {
      liteDelegate?.keyPressed?(event, cell: cell)
    }
  }
  
  public override func performKeyEquivalent(with event: NSEvent) -> Bool {
    if allowedKeyCodes.contains(event.keyCode) { return true }
    else { return super.performKeyEquivalent(with: event) }
  }
  
  public func dequeueCell(withIdentifier identifier: NSUserInterfaceItemIdentifier) -> LiteTableCell {
    if reuseQueues[identifier] == nil { reuseQueues[identifier] = Deque<LiteTableCell>() }
    if reuseQueues[identifier]!.isEmpty {
      let cell: LiteTableCell
      if let nib = registeredNibs[identifier] {
        cell = load(fromNib: nib)
      } else if let `class` = registeredClasses[identifier] {
        cell = `class`.init()
      } else { fatalError("Unregistered identifier") }
      NSLayoutConstraint.activate([
      cell.view.widthAnchor.constraint(equalToConstant: bounds.width),
      cell.view.heightAnchor.constraint(equalToConstant: liteDataSource?.cellHeight(self) ?? 0)
        ])
      return cell
    } else {
      return reuseQueues[identifier]!.removeFirst()!
    }
  }
  
  private func load(fromNib nib: NSNib) -> LiteTableCell {
    var viewObjects: NSArray?
    guard nib.instantiate(withOwner: self, topLevelObjects: &viewObjects) else {
      fatalError("Nib cannot be instantiated")
    }
    return (viewObjects!.first { $0 is LiteTableCell } as! LiteTableCell)
  }
  
  private func moveDown() {
    if let nextCell = currentCell.next() {// Next view is on screen
      currentIndex += 1
      highlightedCell?.highlightToggle()
      highlightedCell = nextCell
    } else if currentIndex + 1 < liteDataSource?.numberOfCells(self) ?? 0 {// Next view can be loaded
      if let top = displayDeque.removeFirst() {
        reuseQueues[top.identifier!, default: []].appendLast(top)
        removeView(top.view)
      }
      guard
        let newCell = liteDataSource?.prepareCell(self, at: currentIndex + 1)
      else { return }
      currentIndex += 1
      displayDeque.appendLast(newCell)
      _ = currentCell.next()
      addView(newCell.view, in: .bottom)
      highlightedCell?.highlightToggle()
      highlightedCell = newCell
    } else { return }
    highlightedCell?.highlightToggle()
  }
  
  private func moveUp() {
    if let prevCell = currentCell.previous() {
      currentIndex -= 1
      highlightedCell?.highlightToggle()
      highlightedCell = prevCell
      highlightedCell?.highlightToggle()
    } else if currentIndex - 1 >= 0 {
      if let bottom = displayDeque.removeLast() {
        reuseQueues[bottom.identifier!, default: []].appendLast(bottom)
        removeView(bottom.view)
      }
      guard
        let newCell = liteDataSource?.prepareCell(self, at: currentIndex - 1)
      else { return }
      currentIndex -= 1
      displayDeque.appendFirst(newCell)
      _ = currentCell.previous()
      insertView(newCell.view, at: 0, in: .top) // Add view to the top
      highlightedCell?.highlightToggle()
      highlightedCell = newCell
      highlightedCell?.highlightToggle()
    } else {
      currentIndex = -1
      currentCell = displayDeque.makeIterator()
      highlightedCell?.highlightToggle()
      highlightedCell = nil
    }
  }
}
