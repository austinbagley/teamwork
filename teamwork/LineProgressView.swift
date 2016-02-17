//
//  LineProgressView.swift
//  teamwork
//
//  Created by Austin Bagley on 2/15/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

@IBDesignable class LineProgressView: UIView {
    
    
    @IBInspectable var baseColor: UIColor = UIColor.grayColor()
    @IBInspectable var progressColor: UIColor = UIColor.greenColor()
    @IBInspectable var percentage: Float = 0.5
    
    override func drawRect(rect: CGRect) {
        
        
        //set up the width and height variables
        //for the horizontal stroke
        let baseHeight: CGFloat = 8.0
        let baseWidth: CGFloat = bounds.width - 8
        let basePath = UIBezierPath()
        
        basePath.lineWidth = baseHeight
        basePath.lineCapStyle = CGLineCap.Round

        
        //move the initial point of the path
        //to the start of the horizontal stroke
        basePath.moveToPoint(CGPoint(
            x:8,
            y:8))
        
        //add a point to the path at the end of the stroke
        basePath.addLineToPoint(CGPoint(
            x:baseWidth,
            y:8))
        
        
        //set the stroke color
        baseColor.setStroke()
        
        //draw the stroke
        basePath.stroke()
        
        let progressPercentage: Float = min(percentage, 1)
        let progressWidth = CGFloat(progressPercentage) * (baseWidth - 8)
        let progressEndPoint = progressWidth + 8
        
        let progressPath = UIBezierPath()
        progressPath.lineWidth = baseHeight
        progressPath.lineCapStyle = CGLineCap.Round
        
        progressPath.moveToPoint(CGPoint(
            x:8,
            y:8))
        
        progressPath.addLineToPoint(CGPoint(
            x:progressEndPoint,
            y:8))
        
        progressColor.setStroke()
        
        progressPath.stroke()
        
        
        
        
    }
}