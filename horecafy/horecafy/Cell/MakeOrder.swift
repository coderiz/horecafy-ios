//
//  MakeOrder.swift
//  horecafy
//
//  Created by iOS User 1 on 02/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

protocol btnDeleteOrderDelegate {
    func BtnDeleteMethod(btnIndex:Int)
}


class MakeOrder: UITableViewCell {

    @IBOutlet weak var txtProductName: UITextField!
    
    @IBOutlet weak var txtQuantity: UITextField!
    
    @IBOutlet weak var lblIndex: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    var DeleteOrderDelegate:btnDeleteOrderDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //IB Action Method
    
    @IBAction func btnDeleteOrderAction(_ sender: UIButton) {
        self.DeleteOrderDelegate.BtnDeleteMethod(btnIndex: sender.tag)
    }
    
    
}
