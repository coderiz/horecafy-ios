import UIKit

class OfferCell: UITableViewCell {
    @IBOutlet weak var customerNameLB: UILabel!
    @IBOutlet weak var zipCodeLB: UILabel!
    @IBOutlet weak var createdOnLB: UILabel!
    @IBOutlet weak var familyLB: UILabel!
    
    func configureCell(demand: DemandsByWholeSaler)  {
        self.customerNameLB.text = demand.customerId
        self.zipCodeLB.text = demand.zipCode
        self.createdOnLB.text = demand.createdOn.ToString
    }
}
