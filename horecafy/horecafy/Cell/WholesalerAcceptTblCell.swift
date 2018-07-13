//
//  WholesalerAcceptTblCell.swift
//  horecafy
//
//  Created by iOS User 1 on 04/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit
protocol WholesalerAcceptCellDelegate {
    //  func AcceptRequest(BtnIndex:Int)
    func SetTime(BtnIndex:Int)
}


class WholesalerAcceptTblCell: UITableViewCell {
    
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblResaurantDesc: UILabel!
    
    
//    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnSetTime: UIButton!
    @IBOutlet weak var lblAcceptStatus: UILabel!
    
    var AcceptCellDelegate:WholesalerAcceptCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //IBAction Methods
    

    @IBAction func btnSetTimeAction(_ sender: UIButton) {
        self.AcceptCellDelegate.SetTime(BtnIndex: sender.tag)
    }
    

    @IBAction func btnAcceptAction(_ sender: UIButton) {
//        self.AcceptCellDelegate.AcceptRequest(BtnIndex: sender.tag)
        
    }
    
}
