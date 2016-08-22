//
//  UBTableViewCell.swift
//  week_3_part_1
//
//  Created by Lin Yi-Cheng on 2016/4/26.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit

// Setting Protocol for delegation
// 法定代理人的法定權力
protocol CellDelegation {
    
    func cell(cell: UBTableViewCell, viewMap sender: AnyObject?)
    func cellSelector(cell: UBTableViewCell, sender: AnyObject?)
    // 為了存取 lat and lng，採用 cell: UBTableViewCell，於 TableViewController 也要改
}


class UBTableViewCell: UITableViewCell {
    
    // Connecting the UIButton of ViewMap
    @IBOutlet weak var viewMap: UIButton!
    
    var delegate: CellDelegation? //宣告法定代理人之權力
    
    //setting the variables for TableviewController to accessing and savign values for selecting Cell through delegation  
    var lat: Double = 0.0
    var lng: Double = 0.0
    var address: String = ""
    var addressEn: String = ""
    var addressSubtitle: String = ""
    var addressSubtitleEn: String = ""
    var bikeNumber: String = ""
    var showCell = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Setting appereance of the table view cell
        self.backgroundColor = UIColor.ybkPaleColor()
        _ = self.viewWithTag(1) as! UIImageView
        
        let textLabel2 = self.viewWithTag(2) as! UILabel
        
        textLabel2.textColor = UIColor.ybkBrownishColor()
        textLabel2.font = UIFont.ybkTextStyle2Font()
        
        let textLabel3 = self.viewWithTag(3) as! UILabel
        textLabel3.textColor = UIColor.ybkSandBrownColor()
        textLabel3.font = UIFont.ybkTextStyle3Font()
        
        let textLabel4 = self.viewWithTag(4) as! UILabel
        textLabel4.textColor = UIColor.ybkDarkSalmonColor()
        textLabel4.font = UIFont.ybkTextStyleFont()
        
        let textLabel5 = self.viewWithTag(5) as! UILabel
        textLabel5.textColor = UIColor.ybkSandBrownColor()
        textLabel5.font = UIFont.ybkTextStyle4Font()
        
        let textLabel6 = self.viewWithTag(6) as! UILabel
        textLabel6.textColor = UIColor.ybkSandBrownColor()
        textLabel6.font = UIFont.ybkTextStyle4Font()
        let viewLine = self.viewWithTag(8)! as UIView
        viewLine.backgroundColor = UIColor.ybkDarkSandColor()
        
        
        // Setting the apperance of ViewMap Button
        viewMap.setTitle(NSLocalizedString("看地圖", comment: "view the map button") , forState: UIControlState.Normal)
        viewMap.setTitleColor(UIColor.ybkDarkSalmonColor(), forState: UIControlState.Normal)
        viewMap.layer.cornerRadius = 4
        viewMap.layer.borderWidth = 1
        viewMap.layer.borderColor = UIColor.ybkDarkSalmonColor().CGColor
        
        
        // Add action for the ViewMap Button and triggering the mapDelegate function
        viewMap.addTarget(self, action: #selector(viewMapButtonDelegate(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    // Ask TableView Controller to act the View Map Button
    func viewMapButtonDelegate(sender: UIButton) {
        delegate?.cell(self,viewMap: sender) //委託法定代理人行使權力

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
         delegate?.cellSelector(self, sender: self)
    }
    
}
