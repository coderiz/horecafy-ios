import UIKit

class WholeSalerShowListsViewController: UIViewController {
    var category: Category?
    private var lists = [ListsByWholeSaler]()
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var listsTVC: UITableView!
   
    @objc func didtapInAddbutton() {}
    override func viewDidLoad() {
        super.viewDidLoad()
        listsTVC.delegate = self
        listsTVC.dataSource = self
        listsTVC.tableFooterView = UIView()
        
        setupUI()
        loadDataFromApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadDataFromApi()
    }
    
    //MARK: Actions
    @IBAction func btnAddAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: WHOLESALER_LIST_ADD, sender: nil)
        
    }

    // MARK: UI
    private func setupUI() {
        if let category = self.category {
            title = category.name
            categoryName.text = category.name
        }
    }
    // MARK: API
    private func loadDataFromApi() {
        guard let category = self.category else {
            return
        }
        
        let wholeSalerId = loadCredentials().userId
        ApiService.instance.getListsByWholeSaler(wholeSalerId: wholeSalerId, categoryId: category.id) { (result) in
            guard let result: [ListsByWholeSaler] = result as? [ListsByWholeSaler] else {
                print("NO lists were loaded from api")
                return
            }
            self.lists = result
            self.listsTVC.reloadData()
        }
        
        if let category = self.category {
            ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
                guard let data: Data = data as? Data else {
                    print("NO category image were loaded from api")
                    return
                }
                self.categoryImage.image = UIImage(data: data)
            }
        }
    }
    
    func deleteItem(cell: UITableViewCell) {
        if let deletionIndexPath = listsTVC.indexPath(for: cell) {
            let listsToDelete = lists[deletionIndexPath.row]
            
            lists.remove(at: deletionIndexPath.row)
            // Call api to delete the demands
            ApiService.instance.deleteList(listId: listsToDelete.id, completion: { result in
                if result == nil {
                    debugPrint("Error in the delete call")
                }
                NotificationCenter.default.post(name: Notification.Name("updateAddedCategoryCheckBox"), object: nil)
            })
            listsTVC.beginUpdates()
            listsTVC.deleteRows(at: [deletionIndexPath], with: .fade)
            listsTVC.endUpdates()
        }
    }
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WHOLESALER_LIST_ADD {
            let vc = segue.destination as! WholeSalerFamlilyListViewController
            vc.category = self.category
            
        }
    }
}
// MARK: UITableViewDelegate, UITableViewDataSource
extension WholeSalerShowListsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listsTVC.dequeueReusableCell(withIdentifier: "listCellId", for: indexPath) as! WholeSalerListCell
        
        let list: ListsByWholeSaler = lists[indexPath.item]
        
        cell.configureCell(list: list)
        cell.parentTableViewController = self
        
        cell.selectionStyle = .none
        return cell
    }
}

