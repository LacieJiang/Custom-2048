//
//  GameboardView.swift
//  Custom-2048
//
//  Created by Jiang Liyin on 14-6-22.
//  Copyright (c) 2014年 liyinjiang. All rights reserved.
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
}
