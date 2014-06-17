//
//  MergeTile.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/17/14.
//  Copyright (c) 2014 liyinjiang. All rights reserved.
//

import UIKit

enum MergeTileMode: Int {
  case Empty
  case NoAction
  case Move
  case SingleCombine
  case DoubleCombine
}

class MergeTile: NSObject {
  var mode: MergeTileMode = MergeTileMode.Empty
  var originalIndexA: NSInteger = 0
  var originalIndexB: NSInteger = 0
  var value: NSInteger = 0

  func description() -> String {
    var modelStr: String?
    switch(self.mode) {
    case .Empty:
      modelStr = "Empty"
    case .NoAction:
      modelStr = "NoAction"
    case .Move:
      modelStr = "Move"
    case .SingleCombine:
      modelStr = "SingleCombine"
    case .DoubleCombine:
      modelStr = "DoubleCombine"
    }
    return "MergeTile (mode: \(modelStr), source1: \(originalIndexA)), source2: \(originalIndexB), value: \(value))"
  }
}
