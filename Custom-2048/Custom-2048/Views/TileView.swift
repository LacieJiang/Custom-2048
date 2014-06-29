//
//  TileView.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/19/14.
//  Copyright (c) 2014 liyinjiang. All rights reserved.
//

import UIKit

class TileView: UIView {
  var value: UInt = 0 {
  didSet {
    backgroundColor = delegate.tileColorFor(value)
    numberLabel.textColor = delegate.numberColorFor(value)
    numberLabel.text = "\(value)"
  }
  }
  var delegate: TileAppearanceProviderProtocol

  var numberLabel: UILabel


  init(position: CGPoint, width: CGFloat, value: UInt, cornerRadius: CGFloat, delegate: TileAppearanceProviderProtocol) {
    self.delegate = delegate
    self.value = value
    numberLabel = UILabel(frame: CGRectMake(0, 0, width, width))
    numberLabel.textAlignment = NSTextAlignment.Center
    numberLabel.minimumScaleFactor = 0.5
    numberLabel.font = delegate.fontForNumbers()
    super.init(frame: CGRectMake(position.x, position.y, width, width))
    self.addSubview(numberLabel)
    self.layer.cornerRadius = cornerRadius
    backgroundColor = delegate.tileColorFor(value)
    numberLabel.textColor = delegate.numberColorFor(value)
    numberLabel.text = "\(value)"
  }
}
