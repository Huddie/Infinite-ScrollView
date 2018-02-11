//
//  InfiniteScrollView.swift
//  InfiniteScrollView
//
//  Created by Ehud Adler on 2/7/18.
//  Copyright © 2018 Ehud Adler. All rights reserved.
//

import UIKit

public enum direction
{
  case left
  case right
}


public protocol InfiniteScrollViewDataSource: class
{
  func infiniteItemForDirection(_ direction: direction) -> UIView
}

public class InfiniteScrollView: UIScrollView
{
  
  /*********** fileprivate **************************/
  fileprivate  var visibleView         = [UIView]()
  fileprivate  var container           = UIView()
  
  /*********** public *****************************/
  public var infiniteDelegate    : InfiniteScrollViewDataSource?

  /*********** init *****************************/
  override init(frame: CGRect)
  {
    super .init(frame: frame)
    self.setUp()
  }
  
  required public init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    self.setUp()
  }
  
  // recenter content periodically to achieve impression of infinite scrolling
  override public func layoutSubviews()
  {
    
    super.layoutSubviews()

    self.contentSize = CGSize(width: self.frame.width*4, height: self.frame.height)
    self.container.frame =  CGRect(x: 0, y: 0,
                                        width: self.contentSize.width, height: self.contentSize.height)
    
    recenterIfNecessary()
    
    let visBounds    = self.bounds
    let minVisBounds = visBounds.minX - self.frame.width
    let maxVisBounds = visBounds.maxX

    placeViews(min: minVisBounds, max: maxVisBounds)
    
  }
}

extension InfiniteScrollView {
  
  /*********** Private *****************************/
  fileprivate func setUp()
  {
    self.addSubview(container)
  }
  
  fileprivate func recenterIfNecessary()
  {
    let currentOffset      = self.contentOffset
    let contentWidth       = self.contentSize.width
    

    let centerOffsetX      = (contentWidth - (self.bounds.size.width)) / 2.0
    let distanceFromCenter = fabs((currentOffset.x) - centerOffsetX)
    
    if (distanceFromCenter > (contentWidth / 4.0))
    {
      self.contentOffset = CGPoint(x: centerOffsetX,
                                   y:  (currentOffset.y))
      
      // move content by the same amount so it appears to stay still
      for view in visibleView
      {
        var center  = view.center
        center.x   += centerOffsetX - currentOffset.x
        view.center = center
      }
    }
  }
  
  // Correctly building, add to view and return for proper placement
  fileprivate func createBuilding(direction: direction) -> UIView
  {
    let newView    = infiniteDelegate?.infiniteItemForDirection(direction)
    if let newView = newView
    {
      newView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
      container.addSubview(newView)
      return newView
    }
    assert(true, "Cannot pass in blank view")
    return UIView()
  }
  
  // Correctly place view on the right edge
  fileprivate func placeNewOnRight(rightEdge: CGFloat) -> CGFloat
  {
    
    let newView = createBuilding(direction: .right)
    visibleView.append(newView)
    
    var newframe      = newView.frame
    newframe.origin.x = rightEdge
    newView.frame     = newframe
    
    return newframe.maxX
    
  }
  
  // Correctly place view on the left edge
  fileprivate func placeNewOnLeft(leftEdge: CGFloat) -> CGFloat
  {
    
    let newView = createBuilding(direction: .left)
    visibleView.insert(newView, at: 0)
    
    var newframe      = newView.frame
    newframe.origin.x = leftEdge - newframe.size.width
    newView.frame     = newframe
    
    return newframe.minX
    
  }
  
  fileprivate func placeViews(min: CGFloat, max: CGFloat)
  {
    
    // There must be atleast 1 view in the visible array for this function to run properly.
    // Therefore, to start, we make sure that atleast one view exists
    
    if visibleView.count < 1 { _ = self.placeNewOnRight(rightEdge: min) }
    
    // Add views that are missing on right side
    var lastView           = visibleView.last
    var rightEdge: CGFloat = (lastView?.frame.maxX)!
    while rightEdge < max {
      print("RIGHT", rightEdge, max)
      rightEdge = self.placeNewOnRight(rightEdge: rightEdge)
      
    }
    
    // Add views that are missing on left side
    var firstView         = visibleView.first
    var leftEdge: CGFloat = (firstView?.frame.minX)!
    while leftEdge > min + self.frame.width { leftEdge = self.placeNewOnLeft(leftEdge: leftEdge) }
    
    // Remove views that have fallen off the right edge
    lastView = visibleView.last
    while (lastView?.frame.origin.x)! > max
    {
      lastView?.removeFromSuperview()
      visibleView.removeLast()
      lastView = visibleView.last
    }
    
    // Remove views that have fallen off the left edge
    firstView = visibleView.first
    while (firstView?.frame.origin.x)! < min
    {
      firstView?.removeFromSuperview()
      visibleView.removeFirst()
      firstView = visibleView.first
    }
  }
}

