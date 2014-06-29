//
//  GameboardView.swift
//  Custom-2048
//
//  Created by Jiang Liyin on 14-6-22.
//

import UIKit


class GameboardView: UIView {
  let tilePopStartScale: CGFloat = 0.1
  let tilePopMaxScale: CGFloat = 1.1
  let tilePopDelay: NSTimeInterval = 0.05
  let tileExpandTime: NSTimeInterval = 0.18
  let tileContractTime: NSTimeInterval = 0.08

  let tileMergeStartScale: CGFloat = 1.0
  let tileMergeExpandTime: NSTimeInterval = 0.08
  let tileMergeContractTime: NSTimeInterval = 0.08

  let perSquareSlideDuration: NSTimeInterval = 0.08

  var boardTiles: Dictionary<NSIndexPath, TileView>
  var dimension: UInt
  var tileSideLength: CGFloat
  var padding: CGFloat
  var cornerRadius: CGFloat
  var provider: TileAppearanceProvider

  init(dimension d: UInt, width: CGFloat, padding p: CGFloat, cornerRadius radius: CGFloat, backgroundColor bgColor: UIColor, foregroundColor fgColor: UIColor) {
    boardTiles = Dictionary()
    dimension = d
    padding = p
    tileSideLength = width
    cornerRadius = radius
    provider = TileAppearanceProvider()
    let sideLength = padding + CGFloat(dimension) * (width + padding)
    super.init(frame: CGRect(x:0, y:0, width: sideLength, height: sideLength))
    layer.cornerRadius = radius
    self.setupBackground(backgroundColor: bgColor, foregroundColor: fgColor)
  }

  func setupBackground(backgroundColor bgColor: UIColor, foregroundColor fgColor: UIColor) {
    backgroundColor = bgColor
    var xCursor = self.padding
    var yCursor: CGFloat = 0.0
    var radius = self.cornerRadius - 2
    if radius < 0 {
      radius = 0
    }
    for i in 0..dimension {
      yCursor = self.padding
      for j in 0..dimension {
        var bkgTile: UIView = UIView(frame: CGRect(x: xCursor, y: yCursor, width: self.tileSideLength, height: self.tileSideLength))
        bkgTile.layer.cornerRadius = radius
        bkgTile.backgroundColor = fgColor
        self.addSubview(bkgTile)
        yCursor += self.padding + self.tileSideLength
      }
      xCursor += self.padding + self.tileSideLength
    }
  }

  func reset() {
    for (key, value) in self.boardTiles {
      var tile: TileView = value
      tile.removeFromSuperview()
    }
    self.boardTiles.removeAll(keepCapacity: true)
  }

  func insertTile(at: (Int, Int), value: UInt) {
    let (row, col) = at
    let x: CGFloat = self.padding + CGFloat(col) * (self.tileSideLength + self.padding)
    let y: CGFloat = self.padding + CGFloat(row) * (self.tileSideLength + self.padding)
    let position: CGPoint = CGPoint(x:x, y:y)
    var radius = self.cornerRadius - 2
    if radius < 0 {
      radius = 0
    }
    var tile: TileView = TileView(position: position, width: self.tileSideLength, value: value, cornerRadius: radius, delegate: provider)
    tile.layer.setAffineTransform(CGAffineTransformMakeScale(tilePopStartScale, tilePopStartScale))

    self.addSubview(tile)
    self.boardTiles[NSIndexPath(forRow: row, inSection: col)] = tile

    UIView.animateWithDuration(tileExpandTime,
      delay: tilePopDelay, options: UIViewAnimationOptions.TransitionNone,
      animations: {() -> Void in
        tile.layer.setAffineTransform(CGAffineTransformMakeScale(self.tilePopMaxScale, self.tilePopMaxScale))
      },
      completion: { (finished: Bool) -> Void in
        UIView.animateWithDuration(self.tileContractTime,
          animations: { () -> Void in
            tile.layer.setAffineTransform(CGAffineTransformIdentity)
          })
      })
  }

  func moveTwoTiles(one: (Int, Int), two: (Int, Int), to: (Int, Int), value: UInt) {
    var startA: NSIndexPath = NSIndexPath(forRow: one.0, inSection: one.1)
    var startB: NSIndexPath = NSIndexPath(forRow: two.0, inSection: two.1)
    var end: NSIndexPath = NSIndexPath(forRow: to.0, inSection: to.1)
    var tileA: TileView = self.boardTiles[startA]!
    var tileB: TileView = self.boardTiles[startB]!
    var x = self.padding + CGFloat(to.1) * (self.tileSideLength + self.padding)
    var y = self.padding + CGFloat(to.0) * (self.tileSideLength + self.padding)
    var finalFrame = tileA.frame
    finalFrame.origin.x = x
    finalFrame.origin.y = y
    self.boardTiles.removeValueForKey(startA)
    self.boardTiles.removeValueForKey(startB)
    self.boardTiles[end] = tileA

    UIView.animateWithDuration(perSquareSlideDuration,
      delay: 0,
      options: .BeginFromCurrentState,
      animations: {() -> Void in
        tileA.frame = finalFrame
        tileB.frame = finalFrame
      },
      completion: {(finished: Bool) -> Void in
        tileA.value = value
        if !finished {
          tileB.removeFromSuperview()
          return
        }
        tileA.layer.setAffineTransform(CGAffineTransformMakeScale(self.tileMergeStartScale, self.tileMergeStartScale))
        tileB.removeFromSuperview()
        UIView.animateWithDuration(self.tileMergeExpandTime,
          animations: {() -> Void in
            tileA.layer.setAffineTransform(CGAffineTransformMakeScale(self.tilePopMaxScale, self.tilePopMaxScale))
          },
          completion: {(finished: Bool) -> Void in
            UIView.animateWithDuration(self.tileMergeContractTime,
              animations: {() -> Void in
                tileA.layer.setAffineTransform(CGAffineTransformIdentity)
              },
              completion: {(Bool) -> Void in})
        })
    })
  }

  func moveOneTile(from: (Int, Int), to: (Int, Int), value: UInt) {
    var start: NSIndexPath = NSIndexPath(forRow: from.0, inSection: from.1)
    var end: NSIndexPath = NSIndexPath(forRow: to.0, inSection: to.1)
    var tile: TileView = boardTiles[start]!
    let endTile = boardTiles[end]
    var shouldPop = (endTile != nil)
    var x = self.padding + CGFloat(to.1) * (self.tileSideLength + self.padding)
    var y = self.padding + CGFloat(to.0) * (self.tileSideLength + self.padding)
    var finalFrame = tile.frame
    finalFrame.origin.x = x
    finalFrame.origin.y = y
    self.boardTiles.removeValueForKey(start)
    self.boardTiles[end] = tile

    UIView.animateWithDuration(perSquareSlideDuration,
      delay: 0,
      options: .BeginFromCurrentState,
      animations: {() -> Void in
        tile.frame = finalFrame
      },
      completion: {(finished: Bool) -> Void in
        tile.value = value
        if !shouldPop || !finished {
          return
        }
        tile.layer.setAffineTransform(CGAffineTransformMakeScale(self.tileMergeStartScale, self.tileMergeStartScale))
        endTile?.removeFromSuperview()
        UIView.animateWithDuration(self.tileMergeExpandTime,
          animations: {() -> Void in
            tile.layer.setAffineTransform(CGAffineTransformMakeScale(self.tilePopMaxScale, self.tilePopMaxScale))
          },
          completion: {(finished: Bool) -> Void in
            UIView.animateWithDuration(self.tileMergeContractTime,
              animations: {() -> Void in
                tile.layer.setAffineTransform(CGAffineTransformIdentity)
              },
              completion: {(Bool) -> Void in})
          })
      })
  }
}
