//
//  ViewController.swift
//  InfScrollView
//
//  Created by Ehud Adler on 2/7/18.
//  Copyright © 2018 Ehud Adler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InfiniteScrollViewDataSource
{


  let infiniteSV = InfiniteScrollView()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()

    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    self.view.addSubview(infiniteSV)
    
    infiniteSV.translatesAutoresizingMaskIntoConstraints = false
    infiniteSV.topAnchor.constraint(equalTo: self.view.topAnchor).isActive       = true
    infiniteSV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    infiniteSV.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive   = true
    infiniteSV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive     = true
        
    infiniteSV.infiniteDelegate = self

  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func infiniteItem(_ lastView: UIView?, _ direction: direction) -> UIView {
    let view = UIView()
    view.backgroundColor = generateRandomColor()
    return view
  }
}

// Generate random color
func generateRandomColor() -> UIColor
{
  let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
  let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
  let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
  
  return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}
