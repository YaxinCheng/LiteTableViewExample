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
  private var registeredNibs: [NSUserInterfaceItemIdentifier: NSNib] = [:]
  private var registeredClasses: [NSUserInterfaceItemIdentifier: LiteTableCell.Type] = [:]
  private var reuseQueues: [NSUserInterfaceItemIdentifier: Deque<LiteTableCell>] = [:]
  
  enum Position {
    case top
    case bottom
  }
  
  public required init?(coder decoder: NSCoder) {
    displayDeque = Deque<LiteTableCell>()
    
    super.init(coder: decoder)
    distribution = .fillEqually
    spacing = 0
  }
  
  public func reload() {
    if displayDeque.count > 0 { displayDeque.removeAll() }
    let threshold = liteDelegate?.cellReuseThreshold(self) ?? -extraSupplyment
    let itemCount = liteDataSource?.numberOfCells(self) ?? 0
    for index in 0 ..< min(threshold + extraSupplyment, itemCount) {
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
}
