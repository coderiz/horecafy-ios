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
    
    @IBAction func deleteTapped(_ sender: Any) {
        print(self.demand?.hiddenId ?? "")
        self.parentTableViewController?.deleteItem(cell: self)
    }
    
    func configureCell(demand: DemandsByCustomer)  {
        self.demand = demand
        self.customer = demand.Customer
        self.family = demand.family
        self.familyName.text = family?.name
    }
}
