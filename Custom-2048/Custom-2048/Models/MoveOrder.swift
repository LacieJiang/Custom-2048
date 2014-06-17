//
//  MoveOrder.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/17/14.
//  Copyright (c) 2014 liyinjiang. All rights reserved.
//

import UIKit

class MoveOrder: NSObject {
  var source1: NSInteger = 0
  var source2: NSInteger = 0
  var destination: NSInteger = 0
  var doubleMove: Bool = false
  var value: NSInteger = 0

  class func singleMoveOrderWithSource(source:NSInteger, destination:NSInteger, newValue:NSInteger) -> MoveOrder {
    var order = MoveOrder()
    order.doubleMove = false
    order.source1 = source
    order.destination = destination
    order.value = newValue
    return order
  }

  class func doubleMoveOrderWithFirstSource(source:NSInteger, secondSource:NSInteger, destination:NSInteger, newValue:NSInteger) -> MoveOrder {
    var order: MoveOrder = MoveOrder()
    order.doubleMove = true
    order.source1 = source
    order.source2 = secondSource
    order.destination = destination
    order.value = newValue
    return order
  }

  func description() -> String {
    if (self.doubleMove) {
      return "MoveOrder (double, source1: \(source1), source2: \(source2), destination: \(destination), value:\(value))"
    }
    return "MoveOrder (single, source: \(source1), destination: \(destination), value: \(value))"
  }
}
