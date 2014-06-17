//
//  TileModel.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/17/14.
//  Copyright (c) 2014 liyinjiang. All rights reserved.
//

import UIKit

class TileModel: NSObject {
  var empty: Bool = true
  var value: NSInteger = 0

  func description() -> String {
    if (self.empty) {
      return "Tile (empty)"
    }
    return "Tile (value: \(self.value))"
  }
}
