import UIKit

class WholeSalerFamlilyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var category: Category?
    var families = [Family]()
    @IBOutlet weak var familyTVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        familyTVC.delegate = self
        familyTVC.dataSource = self
        familyTVC.tableFooterView = UIView()
        
        setupUI()
        loadDataFromApi()
    }
    // MARK: UI
    func setupUI() {
        if let category = self.category {
            self.title = category.name
        }
    }
    // MARK: API
    func loadDataFromApi() {
        guard let category = self.category else {
            return
        }
        ApiService.instance.getFamilies(categoryId: category.id) { (result) in
            guard let result: [Family] = result as? [Family] else {
                print("NO Families were loaded from api")
                return
            }
            self.families = result
            self.families.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.familyTVC.reloadData()
        }
    }
    // MARK: UI Table View Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = familyTVC.dequeueReusableCell(withIdentifier: "familyCellId", for: indexPath)
        let family = families[indexPath.item]
        cell.textLabel?.text = family.name
        return cell
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WHOLESALER_FAMILY_ADD_SEGUE {
            let vc = segue.destination as! WholeSalerAddListViewController
            if let itemSelected: IndexPath = self.familyTVC.indexPathForSelectedRow {
                vc.category = self.category
                vc.family = families[itemSelected.item]
            }
            
        }
    }
}
