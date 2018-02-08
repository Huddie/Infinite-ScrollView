//
//  InfScrollView.swift
//  InfScrollView
//
//  Created by Ehud Adler on 2/7/18.
//  Copyright © 2018 Ehud Adler. All rights reserved.
//

import UIKit

class InfScrollView: UIScrollView {

  var visbleArray = [UIView]()
  var container   = UIView()
  
  override init(frame: CGRect) {
    super .init(frame: frame)
    self.contentSize = CGSize(width: self.frame.width*4, height: self.frame.height)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.contentSize = CGSize(width: self.frame.width*4, height: self.frame.height)
    
    container = UIView(frame: CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height))
    container.backgroundColor = .white
    
    self.alwaysBounceHorizontal = true
    
    self.addSubview(container)
  }
  
  private func recenterIfNecessary(){
    let currentOffset = self.contentOffset
    let contentWidth = self.contentSize.width
    let centerOffsetX = (contentWidth - (self.bounds.size.width)) / 2.0
    let distanceFromCenter = fabs((currentOffset.x) - centerOffsetX)
    
    if (distanceFromCenter > (contentWidth / 4.0)) {
      self.contentOffset = CGPoint(x: centerOffsetX, y:  (currentOffset.y))
      
      for view in visbleArray {
        var theCenter = view.center
        theCenter.x += centerOffsetX - currentOffset.x
        view.center = theCenter
      }
    }
  }
  
  override func layoutSubviews() {
    
    super.layoutSubviews()
    
    recenterIfNecessary()
    
    let visBounds = self.bounds
    let minVisBounds = visBounds.minX - self.frame.width
    let maxVisBounds = visBounds.maxX
    
     placeMonths(min: minVisBounds, max: maxVisBounds)
    
  }
  
  private func createBuilding() -> UIView {
    let newView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
    newView.backgroundColor = generateRandomColor()
    container.addSubview(newView)
    return newView
  }
  
  private func placeNewOnRight(rightEdge: CGFloat) -> CGFloat {
    let newView = createBuilding()
    visbleArray.append(newView)
    var newframe = newView.frame
    newframe.origin.x = rightEdge
    newView.frame = newframe
    
    return newframe.maxX
    
  }
  
  private func placeNewOnLeft(leftEdge: CGFloat) -> CGFloat {
    let newView = createBuilding()
    visbleArray.insert(newView, at: 0)
    var newframe = newView.frame
    newframe.origin.x = leftEdge - newframe.size.width
    newView.frame = newframe
    
    print(newframe.origin.x)
    return newframe.minX
  }
  
  private func placeMonths(min: CGFloat, max: CGFloat)
  {
    
    if visbleArray.count < 2 {
     _ = self.placeNewOnRight(rightEdge: min)
    }
    
    var lastView = visbleArray.last
    var rightEdge: CGFloat = (lastView?.frame.maxX)!
    
    while rightEdge < max {
      rightEdge = self.placeNewOnRight(rightEdge: rightEdge)
    }
    
    var firstView = visbleArray.first
    var leftEdge: CGFloat = (firstView?.frame.minX)!
    
    while leftEdge > min {
       leftEdge = self.placeNewOnLeft(leftEdge: leftEdge)
    }
    
    lastView = visbleArray.last
    while (lastView?.frame.origin.x)! > max {
      lastView?.removeFromSuperview()
      visbleArray.removeLast()
      lastView = visbleArray.last
    }
    
    firstView = visbleArray.first
    while (firstView?.frame.origin.x)! < min {
      firstView?.removeFromSuperview()
      visbleArray.removeFirst()
      firstView = visbleArray.first
    }
    
  }
  
  func generateRandomColor() -> UIColor {
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
    
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
  }

}

