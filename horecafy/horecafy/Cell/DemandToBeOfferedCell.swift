//
//  FDemandToBeOfferedCell.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 7/3/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class DemandToBeOfferedCell: UITableViewCell {
    
    var list: ListsByWholeSaler?
    var family: Family?
    
    @IBOutlet weak var familyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(list: ListsByWholeSaler)  {
        self.list = list
        self.family = list.family
        self.familyName.text = family?.name
    }
    
}
