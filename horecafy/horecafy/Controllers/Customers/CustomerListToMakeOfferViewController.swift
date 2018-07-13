import UIKit

class CustomerListToMakeOfferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var category: Category?
    var demands: [DemandsByCustomer] = []
    @IBOutlet weak var caegoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var demandsTVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demandsTVC.delegate = self
        demandsTVC.dataSource = self
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadDataFromApi()
    }
    // MARK: UI
    func setupUI() {
        if let category = self.category {
            self.title = category.name
            self.categoryName.text = category.name
        }
    }
    // MARK: API
    func loadDataFromApi() {
        guard let category = self.category else {
            return
        }
        let credentials = loadCredentials()
        ApiService.instance.getDemandsWithOffers(customerId: credentials.userId, categoryId: category.id) { (result) in
            guard let result = result as? [DemandsByCustomer] else {
                print("NO demands were loaded from api")
                return
            }
            self.demands = result
            self.demandsTVC.reloadData()
        }
        
        if let category = self.category {
            ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
                guard let data: Data = data as? Data else {
                    print("NO category image were loaded from api")
                    return
                }
                self.caegoryImage.image = UIImage.init(data: data)
            }
        }
    }
    // MARK: UI Table View Controller
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demands.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = demandsTVC.dequeueReusableCell(withIdentifier: "customerOfferCellId", for: indexPath) as! CustomerOfferTableViewCell
        let demand = demands[indexPath.item]
        cell.offerTitleLabel.text = demand.family.name
        return cell
    }
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerDemandOfferSegue" {
            if let vc = segue.destination as? CustomerCategoryDemandOfferViewController, let itemesSelected = self.demandsTVC.indexPathForSelectedRow  {
                let demand = self.demands[itemesSelected.row]
                vc.demand = demand
                vc.category = category
            }
        }
    }
}
