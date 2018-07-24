//
//  DemandToShareCell.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 24/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class DemandToShareCell: UITableViewCell {
    var demand: DemandsByCustomer?
    
    @IBOutlet weak var familyName: UILabel!
    
    @IBOutlet weak var btnSelect: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func selectItemTapped(_ sender: Any) {
        
        guard let demand = demand else {
            return
        }
        
        let demandId = demand.id
        
        let switchState = sender as! UISwitch
        
        if switchState.isOn {
            print("Selected item -> \(demandId)")
            demandsToShare.append(demandId)
        } else {
            if let ix = demandsToShare.index(of: demandId) {
                demandsToShare.remove(at: ix)
            }
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(demand: DemandsByCustomer)  {
        self.demand = demand
        if demandsToShare.contains(demand.id) {
            self.btnSelect.isOn = true
        }
        else {
            self.btnSelect.isOn = false
        }
        self.familyName.text = demand.family.name
    }
}
