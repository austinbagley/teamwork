//
//  CircleProgressView.swift
//  teamwork
//
//  Created by Austin Bagley on 2/15/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

let NoOfGlasses = 8
let π:CGFloat = CGFloat(M_PI)

@IBDesignable class CircleProgressView: UIView {
    
    @IBInspectable var counter: Int = 5
    @IBInspectable var progressColor: UIColor = UIColor.blueColor()
    @IBInspectable var baseColor: UIColor = UIColor.orangeColor()
    @IBInspectable var percentage: Float = 50
    @IBInspectable var poundsLost: Double = 5
    
    override func drawRect(rect: CGRect) {
        
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let arcWidth: CGFloat = 8
        let startAngle: CGFloat = 3 * π / 4
        
        
        
        let endAngle: CGFloat = π / 4
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        path.lineCapStyle = CGLineCap.Round
        path.lineWidth = arcWidth
        baseColor.setStroke()
        path.stroke()
        
        
        // 1
        
        let percentCG: CGFloat = min(CGFloat(percentage), 1)
        let total: CGFloat = 3 * π / 2
        let newLength: CGFloat = percentCG * total
        let newEndAngle = startAngle + newLength
                
        let newPath = UIBezierPath(arcCenter: center,
                                   radius: radius/2 - arcWidth/2,
                                   startAngle: startAngle,
                                   endAngle: newEndAngle,
                                   clockwise: true)
        
        newPath.lineCapStyle = CGLineCap.Round
        newPath.lineWidth = arcWidth
        progressColor.setStroke()
        newPath.stroke()
        
        
        
        
        
    }
}