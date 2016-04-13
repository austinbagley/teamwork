//
//  DashboardCellView.swift
//  teamwork
//
//  Created by Austin Bagley on 2/9/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

@IBDesignable

class DashboardCellView: UITableViewCell {
    
   
    
    // MARK : Outlets
    
    
    
    @IBOutlet weak var toGo: UILabel!
    @IBOutlet weak var poundsLost: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var lineProgressView: LineProgressView!
    

}
