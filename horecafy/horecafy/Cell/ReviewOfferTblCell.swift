//
//  ReviewOfferTblCell.swift
//  horecafy
//
//  Created by iOS User 1 on 11/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ReviewOfferTblCell: UITableViewCell {

    @IBOutlet weak var lblProduct: UILabel!
    
    @IBOutlet weak var lblProductCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
