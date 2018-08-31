//
//  DemandCell.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 19/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class DemandCell: UITableViewCell {

    var demand: DemandsByCustomer?
    var customer: Customer?
    var family: Family?
    
    var parentTableViewController: CustomerShowDemandsViewController?
    
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet var btnSelectItem: UIButton!
    
    @IBAction func deleteTapped(_ sender: Any) {
        print(self.demand?.hiddenId ?? "")
        self.parentTableViewController?.deleteItem(cell: self)
    }
    
    @IBAction func selectItemTapped(_ sender: UIButton)
    {
        guard let demand = demand else {
            return
        }
        let demandId = demand.id
        
        if sender.isSelected
        {
            print("Selected item -> \(demandId)")
            demandsToShare.append(demandId)
        }
        else
        {
            if let ix = demandsToShare.index(of: demandId) {
                demandsToShare.remove(at: ix)
            }
        }
        
//        let switchState = sender as! UISwitch
//
//        if switchState.isOn {
//            print("Selected item -> \(demandId)")
//            demandsToShare.append(demandId)
//        } else {
//            if let ix = demandsToShare.index(of: demandId) {
//                demandsToShare.remove(at: ix)
//            }
//        }
    }
    
    func configureCell(demand: DemandsByCustomer)  {
        self.demand = demand
        self.customer = demand.Customer
        self.family = demand.family
        self.familyName.text = family?.name
        
//        let demandId = demand.id
//        demandsToShare.append(demandId)
    }
}
