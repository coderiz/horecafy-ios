import UIKit

class CustomerShowDemandsForSharingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var category: CategoryWithFamilyCount?
    var demands: [DemandsByCustomer] = []
    var sharingDemands: Bool = false
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var demandsTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demandsTV.delegate = self
        demandsTV.dataSource = self
        
        self.demandsTV.estimatedRowHeight = 53
        self.demandsTV.rowHeight = UITableViewAutomaticDimension

        setupUI()
        loadDataFromApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        loadDataFromApi()
    }
    
    // MARK: UI
    @IBAction func shareTapped(_ sender: Any) {
        if demandsToShare.count == 0 {
            showAlert(self, WARNING, ZERO_ITEMS_SELECTED)
            return;
        }
        
        sharingDemands = true
        var demandsShared = 0
        for demand in demandsToShare {
            activityIndicator.startAnimating()
            ApiService.instance.shareDemand(demandId: demand) { (result) in
                self.activityIndicator.stopAnimating()
                guard let res: ShareDemandResponse = result as? ShareDemandResponse else {
                    showAlert(self, WARNING, "Se produjo un error al compartir la demanda")
                    print("NO demands were loaded from api")
                    return
                }
                
                if res.error != "" {
                    showAlert(self, WARNING, "Se produjo un error al compartir la demanda")
                    return;
                }
                
                demandsShared += 1;
                if demandsShared == demandsToShare.count {
                    demandsToShare.removeAll()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: THANKS) as! ThanksOfferViewController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sharingDemands {
            sharingDemands = false
            self.navigationController?.popViewController(animated: false)
//            self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        }
    }
    
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
        
        let customerId = loadCredentials().userId
        ApiService.instance.getDemandsByCustomer(customerId: customerId, categoryId: category.id) { (result) in
            guard let result: [DemandsByCustomer] = result as? [DemandsByCustomer] else {
                print("NO demands were loaded from api")
                return
            }
            self.demands = result
            demandsToShare.removeAll()
            for SingleDemand in self.demands {
                let demandId = SingleDemand.id
                
                demandsToShare.append(demandId)
            }
            
            self.demandsTV.reloadData()
        }
        
        if let category = self.category {
           
            ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
                guard let data: Data = data as? Data else {
                    print("NO category image were loaded from api")
                    return
                }
                
                self.categoryImage.image = UIImage.init(data: data)
            }
        }
    }
    // MARK: UI Table View Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demands.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = demandsTV.dequeueReusableCell(withIdentifier: "demandToShareCellId", for: indexPath) as! DemandToShareCell
        
        let demand: DemandsByCustomer = demands[indexPath.item]
        
        cell.configureCell(demand: demand)
        
        return cell
    }
}
