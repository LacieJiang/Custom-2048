//
//  ViewController.swift
//  Custom-2048
//
//  Created by liyinjiang on 6/17/14.
//  Copyright (c) 2014 liyinjiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func playGame(sender: UIButton) {
    let controller: NumberTileGameViewController = NumberTileGameViewController(dimension: 4, threshold: 2048, bkgColor: UIColor.whiteColor(), scoreModuleEnabled: true, buttonControlEnabled: true, swipeControlsEnabled: true)
    self.presentViewController(controller, animated: true, completion: nil)
  }
}

