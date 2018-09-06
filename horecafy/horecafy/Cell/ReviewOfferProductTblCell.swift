//
//  ReviewOfferProductTblCell.swift
//  horecafy
//
//  Created by iOS User 1 on 13/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

protocol ContactDistributorDelegate {
    func ContactDistributor(CustomCell:UITableViewCell)
}

class ReviewOfferProductTblCell: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblBrand: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblFormat: UILabel!
    
    @IBOutlet weak var lblComments: UILabel!

    @IBOutlet weak var btnContact: UIButton!
    
    @IBOutlet weak var btnDecline: MyButton!
    
    @IBOutlet weak var btnPreviewImages: MyButton!
    
    @IBOutlet weak var btnPreviewVideo: MyButton!
    
    var ContactDelegate:ContactDistributorDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnContactAction(_ sender: Any)
    {
        self.ContactDelegate.ContactDistributor(CustomCell: self)
    }
    

}
