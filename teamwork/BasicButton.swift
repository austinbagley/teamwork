//
//  BasicButton.swift
//  teamwork
//
//  Created by Austin Bagley on 2/16/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

@IBDesignable

class BasicButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var bkgColor: UIColor = UIColor.blueColor()
    
    override func drawRect(rect: CGRect) {
        
        let rectWidth: CGFloat = bounds.width
        let rectHeight: CGFloat = bounds.height
        let dims: CGRect = CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight)
        let corner: UIRectCorner = UIRectCorner.AllCorners
        let radii: CGSize = CGSize(width: 8, height: 8)
        
        let rect = UIBezierPath(roundedRect: dims, byRoundingCorners: corner, cornerRadii: radii)
        
        bkgColor.setFill()

        rect.fill()
        
    }

}
