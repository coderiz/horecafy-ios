//
//  ProvinceListCell.swift
//  horecafy
//
//  Created by aipxperts on 17/08/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ProvinceListCell: UITableViewCell {

    @IBOutlet weak var lblProvince:UILabel!
    @IBOutlet var btnSelectProvince: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
