import UIKit

class CustomerCreateListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var categories = [Category]()
    var categoryImageName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        setupUI()
        loadCategoriesFromApi()

    }
    // MARK: UI
    func setupUI() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        title = "Crear lista"
        // CollectionView settings
        let layaout = self.categoriesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layaout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
    }
    // MARK: API
    func loadCategoriesFromApi() {
        
        activityIndicator.startAnimating()
        ApiService.instance.getCategories { (result) in
            self.activityIndicator.stopAnimating()
            guard let result: [Category] = result as? [Category] else {
                print("NO Categories were loaded from api")
                return
            }
            
            self.categories = result
            self.categories.remove(at: 0) // delete the firstone because is just for dropdownlists
            
            var index = 0
            while index < self.categories.count
            {
                self.categoryImageName.append(self.categories[index].image)
                index += 1
            }
            
            self.categoriesCollectionView.reloadData()
        }
    }
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var Categorycount:Int = 1
        if self.categories.count > 0 {
            Categorycount = self.categories.count + 1
        }
        return Categorycount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CategoryCollectionViewCell
        
        if indexPath.row == 0 {
            cell.categoryName.text = "Lista personalizada"
            cell.lblFamilyCounter.isHidden = true
            cell.categoryImage.image = UIImage(named: "icon_CreateList")
        }
        else {
            let category = categories[indexPath.item - 1]
            cell.categoryName.text = category.name
            
            cell.lblFamilyCounter.isHidden = true
            
//            ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
//                guard let data: Data = data as? Data else {
//                    print("NO category image were loaded from api")
//                    return
//                }
//                let image = UIImage.init(data: data)
//                let resizedImage = GlobalData.sharedInstance.resizedImage(withImage: image!, scaledTonewSize: CGSize(width: 150.0, height: 150.0))
//                cell.categoryImage.image = resizedImage//UIImage.init(data: data)
//            }
            cell.categoryImage.sd_setShowActivityIndicatorView(true)
            cell.categoryImage.sd_setIndicatorStyle(.white)
            print(category.image)
            cell.categoryImage.sd_setImage(with: URL(string: "\(URL_CATEGORIES_IMAGE)/\(self.categoryImageName[indexPath.item - 1])"), placeholderImage: nil, options: .refreshCached, completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            self.performSegue(withIdentifier: CUSTOMER_CREATE_FREE_LIST, sender: nil)
        }
        else {
            self.performSegue(withIdentifier: CUSTOMER_SHOW_DEMANDS, sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let widthHeight = (UIScreen.main.bounds.size.width - 40) / 3
//            ([[UIScreen mainScreen]bounds].size.width / 3 ) - 18;
        
        return CGSize(width: widthHeight, height: widthHeight + 20.0)
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == CUSTOMER_SHOW_DEMANDS {
            let vc = segue.destination as! CustomerShowDemandsViewController
            if let itemesSelected: [IndexPath] = self.categoriesCollectionView.indexPathsForSelectedItems {
                vc.category = self.categories[itemesSelected[0].item - 1]
            }
        }
    }
}
