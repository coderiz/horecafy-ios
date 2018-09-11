//
//  ReviewOfferDistributorDetailCell.swift
//  horecafy
//
//  Created by iOS User 1 on 12/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ReviewOfferDistributorDetailCell: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFormat: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnPreviewImages: MyButton!
    @IBOutlet weak var btnPreviewVideo: MyButton!
    
    @IBOutlet weak var btnContact: UIButton!
    
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
