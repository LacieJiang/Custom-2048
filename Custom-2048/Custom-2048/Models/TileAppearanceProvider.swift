//
//  TileAppearanceProvider.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/18/14.
//  Copyright (c) 2014 liyinjiang. All rights reserved.
//

import UIKit

protocol TileAppearanceProviderProtocol {
  func tileColorFor(value: UInt) -> UIColor
  func numberColorFor(value: UInt) -> UIColor
  func fontForNumbers() -> UIFont
}

class TileAppearanceProvider: NSObject, TileAppearanceProviderProtocol {
   func tileColorFor(value: UInt) -> UIColor {
    switch value {
    case 2:
      return UIColor(red: 238.0 / 255, green: 228.0 / 255, blue: 218.0 / 255, alpha: 1)
    case 4:
      return UIColor(red: 237.0/255.0, green: 224.0/255.0, blue: 200.0/255.0, alpha: 1)
    case 8:
      return UIColor(red: 242.0/255.0, green: 177.0/255.0, blue: 121.0/255.0, alpha: 1)
    case 16:
      return UIColor(red: 245.0/255.0, green: 149.0/255.0, blue: 99.0/255.0, alpha: 1)
    case 32:
      return UIColor(red: 246.0/255.0, green: 124.0/255.0, blue: 95.0/255.0, alpha: 1)
    case 64:
      return UIColor(red: 246.0/255.0, green: 94.0/255.0, blue: 59.0/255.0, alpha: 1)
    case 128, 256, 512, 1024, 2048:
      return UIColor(red: 237.0/255.0, green: 207.0/255.0, blue: 114.0/255.0, alpha: 1)
    default:
      return UIColor.whiteColor()
    }
  }

  func numberColorFor(value: UInt) -> UIColor {
    switch value {
      case 2, 4:
        return UIColor(red: 119.0/255, green: 110.0/255, blue: 114.0/255, alpha: 1)
    default:
      return UIColor.whiteColor()
    }
  }

  func fontForNumbers() -> UIFont {
    return UIFont(name: "HelveticaNeue-Bold", size: 20)
  }
}