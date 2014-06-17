//
//  GameModel.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/17/14.
//  Copyright (c) 2014 liyinjiang. All rights reserved.
//

import UIKit

enum MoveDirection: NSInteger {
  case Up
  case Down
  case Left
  case Right
}

protocol GameModelProtocol {
  func scoreChanged(newScore: Int)
  func moveOneTile(#from: (Int, Int), to: (Int, Int), value: Int)
  func moveTwoTiles(#from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int)
  func insertTile(at: (Int, Int), value: Int)
}
class GameModel: NSObject {
  var score: Int = 0

  let dimension: Int
  let winValue: Int
  let delegate: GameModelProtocol
  var gameState: TileModel[]

  var commandQueue: MoveCommand[]
  var timer: NSTimer

  let maxCommands = 100
  let queueDelay = 0.3

  init(dimension d: Int, winValue w: Int, delegate: GameModelProtocol) {
    self.dimension = d
    self.winValue = w
    self.delegate = delegate
    self.gameState = TileModel[](count: (d*d), repeatedValue: TileModel())

    self.commandQueue = MoveCommand[]()
    self.timer = NSTimer()
    super.init()
  }

  func reset() {
    self.score = 0
    self.gameState.removeAll(keepCapacity: true)
    self.timer.invalidate()
  }

// insert
  func insertAtRandomLocationTileWith(value: Int) {
    var openSpots = gameboardEmptySpots()
    if (openSpots.count == 0) {
      return
    }
    let idx = Int(arc4random_uniform(UInt32(openSpots.count - 1)))
    let (x, y) = openSpots[idx]
    insertTile((x, y), value: value)
  }

  func insertTile(at: (Int, Int), value: Int) {
    var tileModel = self.tileFor(at)
    if (!tileModel.empty) {
      return
    }
    tileModel.empty = false
    tileModel.value = value
    self.delegate.insertTile(at, value: value)
  }
// move
  func performUpMove() -> Bool {
    var atLeastOneMove = false
    for column in 0..self.dimension {
      var thisColumnTiles: TileModel[] = TileModel[]()
      for row in 0..self.dimension {
        thisColumnTiles.append(self.tileFor((row, column)))
      }

      var ordersArray = self.merge(thisColumnTiles)
      if ordersArray.count > 0 {
        atLeastOneMove = true
        for i in 0..ordersArray.count {
          var order = ordersArray[i]
          if order.doubleMove {
            let source1 = (order.source1, column)
            let source2 = (order.source2, column)
            let destination = (order.destination, column)
            var source1Tile = self.tileFor(source1)
            source1Tile.empty = true
            var source2Tile = self.tileFor(source2)
            source2Tile.empty = true
            var destinationTile = self.tileFor(destination)
            destinationTile.value = order.value
            destinationTile.empty = false

            self.delegate.moveTwoTiles(from: (source1, source2), to: destination, value: destinationTile.value)
          } else {
            let source = (order.source1, column)
            let destination = (order.destination, column)
            var sourceTile = self.tileFor(source)
            sourceTile.empty = true
            var destinationTile = self.tileFor(destination)
            destinationTile.empty = false
            destinationTile.value = order.value
            self.delegate.moveOneTile(from: source, to: destination, value: destinationTile.value)
          }
        }
      }

    }
    return atLeastOneMove
  }

  func performDownMove() -> Bool {
    var atLeastOneMove = false
    for column in 0..self.dimension {
      var thisColumnTiles: TileModel[] = TileModel[]()
      for (var row = (self.dimension - 1); row >= 0; --row) {
        thisColumnTiles.append(self.tileFor((row, column)))
      }
      var ordersArray = self.merge(thisColumnTiles)
      if ordersArray.count > 0 {
        atLeastOneMove = true
        for i in 0..ordersArray.count {
          let dim = self.dimension - 1
          var order = ordersArray[i]
          if order.doubleMove {
            let source1 = (dim - order.source1, column)
            let source2 = (dim - order.source2, column)
            let destination = (dim - order.destination, column)
            var source1Tile = self.tileFor(source1)
            source1Tile.empty = true
            var source2Tile = self.tileFor(source2)
            source2Tile.empty = true
            var destinationTile = self.tileFor(destination)
            destinationTile.value = order.value
            destinationTile.empty = false

            self.delegate.moveTwoTiles(from: (source1, source2), to: destination, value: destinationTile.value)
          } else {
            let source = (dim - order.source1, column)
            let destination = (dim - order.destination, column)
            var sourceTile = self.tileFor(source)
            sourceTile.empty = true
            var destinationTile = self.tileFor(destination)
            destinationTile.empty = false
            destinationTile.value = order.value
            self.delegate.moveOneTile(from: source, to: destination, value: destinationTile.value)
          }
        }
      }
    }
    return atLeastOneMove
  }

  func performLeftMove() -> Bool {
    var atLeastOneMove = false
    for row in 0..self.dimension {
      var thisRowTiles: TileModel[] = TileModel[]()
      for column in 0..self.dimension {
        thisRowTiles.append(self.tileFor((row, column)))
      }
      var ordersArray: MoveOrder[] = self.merge(thisRowTiles)
      if ordersArray.count > 0 {
        atLeastOneMove = true
        for i in 0..ordersArray.count {
          var order = ordersArray[i]
          if order.doubleMove {
            let source1 = (row, order.source1)
            let source2 = (row, order.source2)
            let destination = (row, order.destination)
            var source1Tile = self.tileFor(source1)
            source1Tile.empty = true
            var source2Tile = self.tileFor(source2)
            source2Tile.empty = true
            var destinationTile = self.tileFor(destination)
            destinationTile.empty = false
            destinationTile.value = order.value
            self.delegate.moveTwoTiles(from: (source1, source2), to: destination, value: order.value)
          } else {
            let source = (row, order.source1)
            let destination = (row, order.destination)
            var sourceTile = self.tileFor(source)
            sourceTile.empty = true
            var destinationTile = self.tileFor(destination)
            destinationTile.empty = false
            destinationTile.value = order.value

            self.delegate.moveOneTile(from: source, to: destination, value: order.value)
          }
        }
      }

    }
    return atLeastOneMove
  }

  func performRightMove() -> Bool {
    var atLeastOneMove = false
    for row in 0..self.dimension {
      var thisRowTiles: TileModel[] = TileModel[]()
      for (var column = self.dimension - 1; column >= 0; --column) {
        thisRowTiles.append(self.tileFor((row, column)))
      }
      var ordersArray = self.merge(thisRowTiles)
      if ordersArray.count > 0 {
        var dim = self.dimension - 1
        atLeastOneMove = true
        for i in 0..ordersArray.count {
          let order = ordersArray[i]
          if order.doubleMove {
            let source1 = (row, dim - order.source1)
            let source2 = (row, dim - order.source2)
            let destination = (row, dim - order.destination)
            var source1Tile = self.tileFor(source1)
            source1Tile.empty = true
            var source2Tile = self.tileFor(source2)
            source2Tile.empty = true
            var destinationTile = self.tileFor(destination)
            destinationTile.empty = false
            destinationTile.value = order.value
            self.delegate.moveTwoTiles(from: (source1, source2), to: destination, value: order.value)
          } else {
            let source = (row, dim - order.source1)
            let destination = (row, dim - order.destination)
            var sourceTile = self.tileFor(source)
            sourceTile.empty = true
            var destinationTile = self.tileFor(destination)
            destinationTile.empty = false
            destinationTile.value = order.value
            self.delegate.moveOneTile(from: source, to: destination, value: order.value)
          }
        }

      }
    }
    return atLeastOneMove
  }
// private
  func moveCommand(direction d: MoveDirection, completion t: (Bool) -> ()) {
    if self.commandQueue.count > maxCommands { return }

    let command = MoveCommand(moveDirection: d, completionFunc: t)
    self.commandQueue.append(command)
    if !timer.valid {
      self.timerFired(timer: timer)
    }
  }

  func timerFired(#timer: NSTimer) {
    if self.commandQueue.count == 0 { return }
    var changed = false
    while self.commandQueue.count > 0 {
      let command = self.commandQueue[0]
      self.commandQueue.removeAtIndex(0)
      switch command.direction {
      case .Up:
        changed = self.performUpMove()
      case .Down:
        changed = self.performDownMove()
      case .Left:
        changed = self.performLeftMove()
      case .Right:
        changed = self.performRightMove()
      }
      command.completion(changed)
      if changed {
        break
      }
    }
    self.timer = NSTimer.scheduledTimerWithTimeInterval(self.queueDelay, target: self, selector: Selector("timerFired:"), userInfo: nil, repeats: false)
  }
  func merge(group: TileModel[]) -> MoveOrder[] {
    var ctr: Int = 0
    // STEP 1: collapse all tiles (remove any interstital space)
    // e.g. |[2] [ ] [ ] [4]| becomes [[2] [4]|
    // At this point, tiles either move or don't move, and their value remains the same
    var stack1: MergeTile[] = MergeTile[]()
    for i in 0..self.dimension {
      let tile = group[i]
      if tile.empty {
        continue
      }
      var mergeTile = MergeTile()
      mergeTile.originalIndexA = i
      mergeTile.value = tile.value
      if i == ctr {
        mergeTile.mode = MergeTileMode.NoAction
      } else {
        mergeTile.mode = MergeTileMode.Move
      }
      stack1.append(mergeTile)
      ctr++
    }
    if stack1.count == 0 {
      return MoveOrder[]()
    } else if stack1.count == 1 {
      if stack1[0].mode == MergeTileMode.Move {
        var mergeTile = stack1[0] as MergeTile
        return [MoveOrder.singleMoveOrderWithSource(mergeTile.originalIndexA, destination: 0, newValue: mergeTile.value)]
      } else {
        return MoveOrder[]()
      }
    }

    // STEP 2: starting from the left, and moving to the right, collapse tiles
    // e.g. |[8][8][4][2][2]| should become |[16][4][4]|
    // e.g. |[2][2][2]| should become |[4][2]|
    // At this point, tiles may become the subject of a single or double merge
    ctr = 0
    var priorMergeHasHappened = false
    var stack2: MergeTile[] = MergeTile[]()
    while (ctr < stack1.count - 1) {
      var mergeTile1 = stack1[ctr] as MergeTile
      var mergeTile2 = stack1[ctr + 1] as MergeTile
      if mergeTile1.value == mergeTile2.value {
        assert(mergeTile1.mode != MergeTileMode.SingleCombine && mergeTile2.mode != MergeTileMode.SingleCombine && mergeTile1.mode != MergeTileMode.DoubleCombine && mergeTile2.mode != MergeTileMode.DoubleCombine, "Should not be able to get in a state where already-combined tiles are recombined")
        if mergeTile1.mode == MergeTileMode.NoAction && !priorMergeHasHappened {
          priorMergeHasHappened = true
          var newTile: MergeTile = MergeTile()
          newTile.mode = MergeTileMode.SingleCombine
          newTile.originalIndexA = mergeTile2.originalIndexA
          newTile.value = mergeTile1.value * 2
          self.score += newTile.value
          stack2.append(newTile)
        } else {
          var newTile: MergeTile = MergeTile()
          newTile.mode = MergeTileMode.DoubleCombine
          newTile.originalIndexA = mergeTile1.originalIndexA
          newTile.originalIndexB = mergeTile2.originalIndexA
          newTile.value = mergeTile1.value * 2
          self.score += newTile.value
          stack2.append(newTile)
        }
        ctr += 2
      } else {
        stack2.append(mergeTile1)
        if stack2.count - 1 != ctr {
          mergeTile1.mode = MergeTileMode.Move
        }
        ctr++
      }
      if ctr == stack1.count - 1 {
        var item = stack1[ctr] as MergeTile
        stack2.append(item)
        if stack2.count - 1 != ctr {
          item.mode = MergeTileMode.Move
        }
      }
    }
    // STEP 3: create move orders for each mergeTile that did change this round
    var stack3: MoveOrder[] = MoveOrder[]()
    for i in 0..stack2.count {
      var tile = stack2[i]
      switch (tile.mode) {
       case .Empty,.NoAction:
        continue
      case .Move, .SingleCombine:
        stack3.append(MoveOrder.singleMoveOrderWithSource(tile.originalIndexA, destination: i, newValue: tile.value))
      case .DoubleCombine:
        stack3.append(MoveOrder.doubleMoveOrderWithFirstSource(tile.originalIndexA, secondSource: tile.originalIndexB, destination: i, newValue: tile.value))
      }
    }
    return stack3
  }
  func gameboardEmptySpots() -> (Int, Int)[] {
    var openSpots = Array<(Int, Int)>()
    for i in 0..self.dimension {
      for j in 0..self.dimension {
        var tileModel = self.tileFor((i, j))
        if (tileModel.empty) {
          openSpots += (i, j)
        }
      }
    }
    return openSpots
  }

  func tileFor(position: (Int, Int)) ->TileModel {
    let idx: Int = position.0 * self.dimension + position.1
    return self.gameState[idx]
  }
}
