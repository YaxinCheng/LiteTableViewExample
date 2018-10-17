//
//  LiteTableController.swift
//  LiteTable
//
//  Created by Yaxin Cheng on 2018-10-10.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

class LiteTableController: NSViewController {
  
  let dataSource = (0...50).map { $0 }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    (view as! LiteTableView).register(nib: NSNib(nibNamed: "TestCell", bundle: .main)!, withIdentifier: .test)
    (view as! LiteTableView).liteDataSource = self
    (view as! LiteTableView).liteDelegate = self
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    
    (view as! LiteTableView).reload()
  }
}

extension LiteTableController: LiteTableDelegate, LiteTableDataSource {
  func cellReuseThreshold(_ tableView: LiteTableView) -> Int {
    return 10
  }
  
  func numberOfCells(_ tableView: LiteTableView) -> Int {
    return 20
  }
  
  func cellHeight(_ tableView: LiteTableView) -> CGFloat {
    return 30
  }
  
  func prepareCell(_ tableView: LiteTableView, at index: Int) -> LiteTableCell {
    let cell = tableView.dequeueCell(withIdentifier: .test) as! TestCell
    let data = dataSource[index]
    cell.numberLabel.stringValue = "\(data)"
    return cell
  }
  
  
}
