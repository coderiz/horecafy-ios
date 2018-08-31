import UIKit

class WholeSalerListToMakeOfferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var category: Category?
    var demands = [DemandsByWholeSaler]()
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
        
        let wholesalerId = loadCredentials().userId
        ApiService.instance.getDemandsByWholeSaler(wholesalerId: wholesalerId, categoryId: category.id) { (result) in
            guard let result = result as? [DemandsByWholeSaler] else {
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
    
    @objc func deleteItem(sender: UIButton) {

        let listsToDelete = demands[sender.tag]
            
        demands.remove(at: sender.tag)

        // Call api to delete the demands
        ApiService.instance.deleteDemand(demandId: Int(listsToDelete.hiddenId)!, completion: { result in
            if result == nil {
                debugPrint("Error in the delete call")
            }
        })
        self.demandsTVC.reloadData()
        
//        ApiService.instance.declineOffer(offerId: listsToDelete.id, completion: { result in
//            guard let ResponseforDecline:DeclineOfferResponse = result as? DeclineOfferResponse else {
//                showAlert(self, ERROR, FAILURE_TO_DECLINE)
//                return
//            }
//            if ResponseforDecline.totalRows != 0 {
//                self.demands.remove(at: sender.tag)
//                self.demandsTVC.reloadData()
//            }
//        })
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
        let cell = demandsTVC.dequeueReusableCell(withIdentifier: "offerCellId", for: indexPath) as! OfferCell
        let demand = demands[indexPath.item]
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteItem(sender:)), for: .touchUpInside)
        
        cell.configureCell(demand: demand)
        return cell
    }
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "WholesalerOfferViewController" {
            let vc = segue.destination as! WholesalerOfferViewController
            if let itemSelected: IndexPath = self.demandsTVC.indexPathForSelectedRow {
                vc.category = self.category
                vc.demand = demands[itemSelected.item]
            }
        }
    }
}
