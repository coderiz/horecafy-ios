//
//  CustomerAcceptTblCell.swift
//  horecafy
//
//  Created by iOS User 1 on 04/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

protocol CustomerAcceptCellDelegate {
    func AcceptRequest(BtnIndex:Int)
    func RejectRequest(BtnIndex:Int)
}

class CustomerAcceptTblCell: UITableViewCell {

    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblResaurantDesc: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    var AcceptCellDelegate:CustomerAcceptCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //IBAction Methods
    
    @IBAction func btnAcceptAction(_ sender: UIButton) {
        self.AcceptCellDelegate.AcceptRequest(BtnIndex: sender.tag)
    }
    
    @IBAction func btnRejectAction(_ sender: UIButton) {
        self.AcceptCellDelegate.RejectRequest(BtnIndex: sender.tag)
    }
    

    
}
