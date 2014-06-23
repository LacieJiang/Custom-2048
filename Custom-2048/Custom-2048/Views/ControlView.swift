//
//  ControlView.swift
//  Custom-2048
//
//  Created by Jiang Liyin on 14-6-22.
//  Copyright (c) 2014年 liyinjiang. All rights reserved.
//

import UIKit

protocol ControlViewProtocol {
  func upButtonTapped()
  func downButtonTapped()
  func leftButtonTapped()
  func rightButtonTapped()
  func resetButtonTapped()
  func exitButtonTapped()
}

class ControlView: UIView {
  var moveButtonsEnabled: Bool = false
  var exitButtonEnabled: Bool = false
  var delegate: ControlViewProtocol
  init(frame: CGRect, cornerRadius: CGFloat, backgroundColor bgColor: UIColor, movementButtonsEnabled: Bool, exitButtonEnabled: Bool, delegate: ControlViewProtocol) {
    self.delegate = delegate
    self.moveButtonsEnabled = movementButtonsEnabled
    self.exitButtonEnabled = exitButtonEnabled
    super.init(frame: frame)
    backgroundColor = bgColor
    layer.cornerRadius = cornerRadius
  }

}
