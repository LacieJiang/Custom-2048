//
//  QueueCommand.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/17/14.
//  Copyright (c) 2014 liyinjiang. All rights reserved.
//

import UIKit

class MoveCommand: NSObject {
  var direction: MoveDirection
  var completion: (Bool) -> ()
  init(moveDirection: MoveDirection, completionFunc: (Bool) -> ()) {
    self.direction = moveDirection
    self.completion = completionFunc
    super.init()
  }
}
