import UIKit

class CustomerShowDemandsViewController: UIViewController
{
    var category: Category?
    var demands = [DemandsByCustomer]()
    var sharingDemands: Bool = false
    
    @IBOutlet weak var caegoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var demandsTVC: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demandsTVC.delegate = self
        demandsTVC.dataSource = self
        demandsTVC.tableFooterView = UIView()
        
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadDataFromApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sharingDemands {
            sharingDemands = false
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: UI
    func setupUI() {
        if let category = self.category {
            title = category.name
            categoryName.text = category.name
        }
    }
    
    //MARK: Actions
    @IBAction func btnAddAction(_ sender: Any) {
     
        self.performSegue(withIdentifier: CUSTOMER_DEMAND_ADD, sender: nil)
        
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
        
        if demandsToShare.count == 0 {
            self.activityIndicator.stopAnimating()
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
                    self.demandsTVC.reloadData()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouForShareViewController") as! ThankYouForShareViewController
                    vc.strMessage = THANKS_FOR_SHARE_LIST
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func selectItemTapped(_ sender: UIButton)
    {
        
        guard let demand: DemandsByCustomer = demands[sender.tag] else {
            return
        }
        let demandId = demand.id
        
        if sender.isSelected == true
        {
            if let ix = demandsToShare.index(of: demandId) {
                demandsToShare.remove(at: ix)
                sender.isSelected = false
            }
        }
        else
        {
            print("Selected item -> \(String(describing: demandId))")
            demandsToShare.append(demandId)
            sender.isSelected = true
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
   
    func deleteItem(cell: UITableViewCell) {

        if let deletionIndexPath = demandsTVC.indexPath(for: cell) {
            let demandToDelete = demands[deletionIndexPath.row]

            demands.remove(at: deletionIndexPath.row)
            // Call api to delete the demands
            ApiService.instance.deleteDemand(demandId: demandToDelete.hiddenId, completion: { result in
                if result == nil {
                    debugPrint("Error in the delete call")
                }
            })
            demandsTVC.beginUpdates()
            demandsTVC.deleteRows(at: [deletionIndexPath], with: .fade)
            demandsTVC.endUpdates()
        }
    }
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CUSTOMER_DEMAND_ADD {
            let vc = segue.destination as! CustomerFamlilyListViewController
            vc.category = self.category
        }
    }
}

extension CustomerShowDemandsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: UI Table View Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demands.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = demandsTVC.dequeueReusableCell(withIdentifier: "demandCellId", for: indexPath) as! DemandCell
        let demand: DemandsByCustomer = demands[indexPath.item]
        
        cell.btnSelectItem.isSelected = false
        cell.btnSelectItem.tag = indexPath.row
        cell.btnSelectItem.addTarget(self, action: #selector(selectItemTapped(_:)), for: .touchUpInside)
        
        if demandsToShare.contains(demand.id)
        {
            cell.btnSelectItem.isSelected = true
        }
        
        cell.configureCell(demand: demand)
        cell.parentTableViewController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerAddListViewControllerID") as? CustomerAddListViewController, let category = category {
            let demandByCustomer = demands[indexPath.row]
            vc.demandByCustomer = demandByCustomer
            vc.category = category
            vc.family = demandByCustomer.family
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
