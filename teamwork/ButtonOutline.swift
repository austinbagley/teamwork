//
//  ButtonOutline.swift
//  teamwork
//
//  Created by Austin Bagley on 2/16/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

@IBDesignable

class ButtonOutline: UIButton {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBInspectable var bkgColor: UIColor = c4
    
    override func drawRect(rect: CGRect) {
        
        let rectWidth: CGFloat = bounds.width - 2
        let rectHeight: CGFloat = bounds.height - 2
        let dims: CGRect = CGRect(x: 1, y: 1, width: rectWidth, height: rectHeight)
        let corner: UIRectCorner = UIRectCorner.AllCorners
        let radii: CGSize = CGSize(width: 4, height: 4)
        
        let rect = UIBezierPath(roundedRect: dims, byRoundingCorners: corner, cornerRadii: radii)
        rect.lineWidth = CGFloat(1.0)
        
        bkgColor.setStroke()
        
        rect.stroke()
        
    }
    
}