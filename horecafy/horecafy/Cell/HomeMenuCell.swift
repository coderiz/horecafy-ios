//
//  HomeMenuCell.swift
//  horecafy
//
//  Created by iOS User 1 on 27/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class HomeMenuCell: UICollectionViewCell {
  
    
    @IBOutlet weak var imgMenu: UIImageView!
    
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    override func awakeFromNib() {
        self.lblCount.layer.cornerRadius = 15.0
        self.lblCount.layer.masksToBounds = true
    }
}
