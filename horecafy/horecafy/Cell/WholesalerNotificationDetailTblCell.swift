//
//  WholesalerNotificationDetailTblCell.swift
//  horecafy
//
//  Created by iOS User 1 on 04/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class WholesalerNotificationDetailTblCell: UITableViewCell {

    
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblResaurantDesc: UILabel!
    @IBOutlet weak var lblAcceptStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var btnPreviewImages: MyButton!
    @IBOutlet weak var btnPreviewVideo: MyButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
