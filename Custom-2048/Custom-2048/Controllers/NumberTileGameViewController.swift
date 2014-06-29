//
//  NumberTileGameViewController.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/18/14.//

import UIKit

protocol NumberTileGameProtocol {
  func gameFinishedWith(victory didWin: Bool, score: Int)
}

class NumberTileGameViewController: UIViewController, GameModelProtocol, ControlViewProtocol {
  var gameboard: GameboardView!
  var gameModel: GameModel!
  var scoreView: ScoreView!
  var controlView: ControlView!
  var delegate: NumberTileGameProtocol?

  var useScoreView: Bool
  var useControlView: Bool
  var dimension: UInt = 0
  var threshold: UInt = 0

  let elementSpacing: CGFloat = 10.0
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupGame()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  init(dimension: UInt, threshold: UInt, bkgColor: UIColor, scoreModuleEnabled: Bool, buttonControlEnabled:Bool, swipeControlsEnabled: Bool) {
    self.dimension = dimension > 2 ? dimension:2
    self.threshold = threshold > 8 ? threshold:8
    self.useScoreView = scoreModuleEnabled
    self.useControlView = buttonControlEnabled
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.whiteColor()
    if swipeControlsEnabled {
      setupSwipeControls()
    }
  }

  func setupGame() {
    var totalHeight: CGFloat = 0.0
    if self.useScoreView {
      self.scoreView = ScoreView(cornerRadius: 6, backgroundColor: UIColor.darkGrayColor(), textColor: UIColor.whiteColor(), textFont: UIFont(name: "HelveticaNeue-Bold", size: 16))
      totalHeight += elementSpacing + scoreView.bounds.size.height
    }
    if self.useControlView {
      self.controlView = ControlView(cornerRadius: 6, backgroundColor: UIColor.blackColor(), movementButtonsEnabled: true, exitButtonEnabled: false, delegate: self)
      totalHeight += elementSpacing + controlView.bounds.size.height
    }

    let padding: CGFloat = self.dimension > 5 ? 3.0:6.0

    var cellWidth: CGFloat = (230 - padding * CGFloat(self.dimension + 1))/CGFloat(self.dimension)
    if cellWidth < 30 {
      cellWidth = 30
    }
    self.gameboard = GameboardView(dimension: self.dimension, width: cellWidth, padding: padding, cornerRadius: 6, backgroundColor: UIColor.blackColor(), foregroundColor: UIColor.darkGrayColor())
    totalHeight += gameboard.bounds.size.height

    var currentTop: CGFloat = 0.5*(self.view.bounds.size.height - totalHeight)
    if currentTop < 0 {
      currentTop = 0
    }
    if self.useScoreView {
      var scoreFrame = scoreView.frame
      scoreFrame.origin.x = 0.5*(self.view.bounds.size.width - scoreFrame.size.width)
      scoreFrame.origin.y = currentTop
      scoreView.frame = scoreFrame
      self.view.addSubview(scoreView)
      currentTop += scoreFrame.size.height + elementSpacing
    }
    var gameFrame = gameboard.frame
    gameFrame.origin.x = 0.5*(self.view.bounds.size.width - gameFrame.size.width)
    gameFrame.origin.y = currentTop
    gameboard.frame = gameFrame
    self.view.addSubview(gameboard)
    currentTop += gameFrame.size.height + elementSpacing

    if self.useControlView {
      var controlFrame = controlView.frame
      controlFrame.origin.x = 0.5*(self.view.bounds.size.width - controlFrame.size.width)
      controlFrame.origin.y = currentTop
      controlView.frame = controlFrame
      self.view.addSubview(controlView)
      currentTop += controlFrame.size.height + elementSpacing
    }

    self.gameModel = GameModel(dimension: Int(self.dimension), winValue: Int(self.threshold), delegate: self)
    gameModel.insertAtRandomLocationTileWith(2)
    gameModel.insertAtRandomLocationTileWith(2)
  }
  func setupSwipeControls() {
    var upSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("upButtonTapped"))
    upSwipe.numberOfTouchesRequired = 1
    upSwipe.direction = UISwipeGestureRecognizerDirection.Up
    self.view.addGestureRecognizer(upSwipe)

    var downSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("downButtonTapped"))
    downSwipe.numberOfTouchesRequired = 1
    downSwipe.direction = UISwipeGestureRecognizerDirection.Down
    self.view.addGestureRecognizer(downSwipe)

    var leftSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("leftButtonTapped"))
    leftSwipe.numberOfTouchesRequired = 1
    leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
    self.view.addGestureRecognizer(leftSwipe)

    var rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("rightButtonTapped"))
    rightSwipe.numberOfTouchesRequired = 1
    rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
    self.view.addGestureRecognizer(rightSwipe)
  }

  func followUp() {
    if self.gameModel.userHasWon() {
      if self.delegate {
        self.delegate!.gameFinishedWith(victory: true, score: self.gameModel.score)
      }
//      let alert = UIAlertController(title: "Victory", message: "You won!", preferredStyle: .Alert)
//      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:nil))
//      self.presentViewController(alert, animated: true, completion: nil)
    } else {
      let rand = arc4random_uniform(10)
      if rand == 1 {
        self.gameModel.insertAtRandomLocationTileWith(4)
      } else {
        self.gameModel.insertAtRandomLocationTileWith(2)
      }
      if self.gameModel.userHasLost() {
//        let alert = UIAlertController(title: "Defeat!", message: "You lost...", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:nil))
//        self.presentViewController(alert, animated: true, completion: nil)
      }
    }
  }

  func handleSwipe(gesture: UISwipeGestureRecognizer) {
    switch(gesture.direction) {
      case UISwipeGestureRecognizerDirection.Up:
        upButtonTapped()
    case UISwipeGestureRecognizerDirection.Down:
      downButtonTapped()
    case UISwipeGestureRecognizerDirection.Left:
      leftButtonTapped()
    case UISwipeGestureRecognizerDirection.Right:
      rightButtonTapped()
    default:
      break
    }

  }
  func upButtonTapped() {
    self.gameModel.moveCommand(direction: MoveDirection.Up, completion: { (finished: Bool) -> Void in
      if finished {
        self.followUp()
      }
    })
  }

  func downButtonTapped()  {
    self.gameModel.moveCommand(direction: MoveDirection.Down, completion: { (finished: Bool) -> Void in
      if finished {
        self.followUp()
      }
      })
  }

  func leftButtonTapped()  {
    self.gameModel.moveCommand(direction: MoveDirection.Left, completion: { (finished: Bool) -> Void in
      if finished {
        self.followUp()
      }
      })
  }
  func rightButtonTapped()  {
    self.gameModel.moveCommand(direction: MoveDirection.Right, completion: { (finished: Bool) -> Void in
      if finished {
        self.followUp()
      }
      })
  }

  func resetButtonTapped() {
    self.gameboard.reset()
    self.gameModel.reset()
    self.gameModel.insertAtRandomLocationTileWith(2)
    self.gameModel.insertAtRandomLocationTileWith(2)
  }
  func exitButtonTapped() {
    self.dismissModalViewControllerAnimated(true)
  }

  func scoreChanged(newScore: Int) {
    self.scoreView.score = newScore
  }
  func moveOneTile(#from: (Int, Int), to: (Int, Int), value: Int) {
    self.gameboard.moveOneTile(from, to: to, value: UInt(value))
  }
  func moveTwoTiles(#from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
    self.gameboard.moveTwoTiles(from.0, two: from.1, to: to, value: UInt(value))
  }
  func insertTile(at: (Int, Int), value: Int) {
    self.gameboard.insertTile(at, value: UInt(value))
  }
}
