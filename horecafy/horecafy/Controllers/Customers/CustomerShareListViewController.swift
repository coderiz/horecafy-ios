import UIKit

class CustomerShareListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var categories = [CategoryWithFamilyCount]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblNoData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadDataFromApi()
    }
    
    // MARK: API CALL
    func loadDataFromApi() {
        
        let credentials = loadCredentials()
        activityIndicator.startAnimating()
        ApiService.instance.getCategoriesDemandWithFamilyCount(customerId: credentials.userId) { (result) in
            self.activityIndicator.stopAnimating()
            guard let result: [CategoryWithFamilyCount] = result as? [CategoryWithFamilyCount] else {
                self.lblNoData.isHidden = false
                return
            }
            if result.isEmpty {
                self.lblNoData.isHidden = false
            }
            self.categories = result
           
            if self.categories.count == 0 {
                self.lblNoData.isHidden = false
            }
            else {
                self.lblNoData.isHidden = true
            }
            
            self.categoriesCollectionView.reloadData()
        }
    }

    
    // MARK: UI
    func setupUI() {
        title = "Compartir lista"
        self.lblNoData.isHidden = true
        self.activityIndicator.hidesWhenStopped  = true
        let layaout = self.categoriesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layaout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
    }
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CustomerShareCategoryCollectionViewCell
        let category = categories[indexPath.item]
        var numberOfRequests = "\(category.familyCount)"
        if (category.familyCount == 1) {
            numberOfRequests += " solicitud"
        }
        else {
            numberOfRequests += " solicitudes"
        }
        cell.numberOfRequests.text = numberOfRequests
        ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
            guard let data: Data = data as? Data else {
                print("NO category image were loaded from api")
                return
            }
            cell.categoryImage.image = UIImage(data: data)
        }
        return cell
    }
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CUSTOMER_SHOW_DEMANDS_FOR_SHARING {
            let vc = segue.destination as! CustomerShowDemandsForSharingViewController
            if let itemesSelected: [IndexPath] = self.categoriesCollectionView.indexPathsForSelectedItems {
                vc.category = self.categories[itemesSelected[0].item]
            }
        }
    }
}
