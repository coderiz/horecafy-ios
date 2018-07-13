//
//  CreateFreeListCell.swift
//  horecafy
//
//  Created by iOS User 1 on 27/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

protocol btnDeleteProtocol {
    func BtnDeleteMethod(btnIndex:Int)
}

class CreateFreeListCell: UITableViewCell {

    @IBOutlet weak var txtFreeList: UITextField!
    
    @IBOutlet weak var lblIndex: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    var DeleteListDelegate:btnDeleteProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //IB Action Methods
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        self.DeleteListDelegate.BtnDeleteMethod(btnIndex: sender.tag)
        
    }
    

}
