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
  func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int)
  func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int)
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
  func merge(group: TileModel[]) -> MoveOrder[] {
    var ctr: Int = 0
    // // STEP 1: collapse all tiles (remove any interstital space)
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

      }
    }

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
