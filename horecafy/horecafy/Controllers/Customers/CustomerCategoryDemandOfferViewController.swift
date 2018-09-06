import UIKit

class CustomerCategoryDemandOfferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var demand: DemandsByCustomer?
    var offersCustomer: [OfferCustomer]?
    var category: Category?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 103
        
        guard let demand = demand else { return }
        let credentials = loadCredentials()
        ApiService().getApprovedCustomerOffers(customerId: credentials.userId, demandId: demand.hiddenId) { result in
            if let offersCustomer = result as? [OfferCustomer] {
                self.offersCustomer = offersCustomer
                print(self.offersCustomer)
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let offersCustomer = offersCustomer else {
            return 0
        }
        return offersCustomer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "offerCellId") as? OfferCell, let offersCustomer = offersCustomer else {
            return UITableViewCell()
        }
        let offer = offersCustomer[indexPath.row]
        if let wholesaler = offer.wholesaler, let date = offer.createdOn {
            cell.customerNameLB.text = "\(wholesaler.hiddenId ?? 0)"
            cell.zipCodeLB.text = wholesaler.zipCode
            cell.createdOnLB.text = date.ToString
            cell.familyLB.text = demand?.family.name
        }
        return cell
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "offerResumeSegue" {
            if let vc = segue.destination as? CustomerOfferViewController, let offersCustomer = offersCustomer, let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                let offer = offersCustomer[indexPathForSelectedRow.row]
                vc.offer = offer
                vc.demand = demand
                vc.category = category
                vc.family = offer.family
            }
        }
    }
}
