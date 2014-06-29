//
//  ScoreView.swift
//  Custom-2048
//
//  Created by Jiang Liyin on 14-6-22.
//  Copyright (c) 2014年 liyinjiang. All rights reserved.
//

import UIKit

protocol ScoreViewProtocol {
  func scoreChanged(newScore: Int)
}

class ScoreView: UIView, ScoreViewProtocol {
  var score: Int = 0 {
  didSet {
    scoreLabel.text = "SCORE: \(score)"
  }
  }

  let defaultFrame = CGRectMake(0, 0, 140, 40)
  var scoreLabel: UILabel

  init(cornerRadius: CGFloat, backgroundColor bgColor: UIColor, textColor: UIColor, textFont: UIFont) {
    score = 0
    scoreLabel = UILabel(frame: defaultFrame)
    scoreLabel.textAlignment = .Center
    if textColor != nil {
      scoreLabel.textColor = textColor
    }
    if textFont != nil {
      scoreLabel.font = textFont
    }
    super.init(frame: frame)
    self.addSubview(self.scoreLabel)
    layer.cornerRadius = cornerRadius
    backgroundColor = (bgColor != nil) ? bgColor : UIColor.whiteColor()
  }

  func scoreChanged(newScore: Int) {
    self.score = newScore
  }
}
