import UIKit

class OfferCell: UITableViewCell {
    @IBOutlet weak var customerNameLB: UILabel!
    @IBOutlet weak var zipCodeLB: UILabel!
    @IBOutlet weak var createdOnLB: UILabel!
    @IBOutlet weak var familyLB: UILabel!
    @IBOutlet var btnDelete: UIButton!
    
    var parentTableViewController: WholeSalerListToMakeOfferViewController?
    
//    @IBAction func deleteTapped(_ sender: Any) {
//        self.parentTableViewController?.deleteItem(cell: self)
//    }
    
    func configureCell(demand: DemandsByWholeSaler)  {
        self.customerNameLB.text = demand.customerId
        self.zipCodeLB.text = demand.zipCode
//        self.createdOnLB.text = demand.createdOn.ToString
        self.createdOnLB.text = demand.sentTo.ToString
        self.familyLB.text = demand.familyName
    }
}
