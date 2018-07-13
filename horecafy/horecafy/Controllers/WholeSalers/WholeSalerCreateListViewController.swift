import UIKit

class WholeSalerCreateListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        setupUI()
        loadCategoriesFromApi()
    }
    // MARK: UI
    func setupUI() {
        title = "Crear lista"
        // CollectionView settings
        let layaout = self.categoriesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layaout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)

    }
    // MARK: API
    func loadCategoriesFromApi() {
        ApiService.instance.getCategories { (result) in
            guard let result: [Category] = result as? [Category] else {
                print("NO Categories were loaded from api")
                return
            }
            self.categories = result
            self.categories.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.categoriesCollectionView.reloadData()
        }
    }
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.item]
        cell.categoryName.text = category.name
        let FamilyCounter = category.totalFamilies
        if FamilyCounter == 0 {
            cell.lblFamilyCounter.isHidden = true
        }
        else {
            cell.lblFamilyCounter.isHidden = false
            if FamilyCounter >= 100 {
                cell.lblFamilyCounter.text = "99+"
            }
            else if FamilyCounter < 100 {
                cell.lblFamilyCounter.text = "\(FamilyCounter)"
            }
        }
        
        ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
            guard let data: Data = data as? Data else {
                print("NO category image were loaded from api")
                return
            }
            cell.categoryImage.image = UIImage.init(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthHeight = (UIScreen.main.bounds.size.width - 40) / 3
        return CGSize(width: widthHeight, height: widthHeight + 20.0)
        
    }
    
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == WHOLESALER_SHOW_LISTS {
            let vc = segue.destination as! WholeSalerShowListsViewController
            if let itemesSelected: [IndexPath] = self.categoriesCollectionView.indexPathsForSelectedItems {
                vc.category = self.categories[itemesSelected[0].item]
            }
        }
    }
}
