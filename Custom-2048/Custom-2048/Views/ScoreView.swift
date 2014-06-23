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

  var scoreLabel: UILabel

  init(frame: CGRect, cornerRadius: CGFloat, backgroundColor bgColor: UIColor, textColor: UIColor, textFont: UIFont) {
    score = 0
    scoreLabel = UILabel(frame: frame)
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
