import UIKit

class WholeSalerMakeOfferCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var categories = [CategoryWithFamilyCount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        setupUI()
        loadDataFromApi()
    }
    // MARK: UI
    func setupUI() {
        self.title = "Realizar oferta"
        let layaout = self.categoriesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layaout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
    }
    
    func loadDataFromApi() {
        let credentials = loadCredentials()
        ApiService.instance.getCategoriesWholesalerListWithFamilyCount(wholesalerId: credentials.userId) { (result) in
            guard let result = result as? [CategoryWithFamilyCount] else {
                print("NO CategoryWithFamilyCount were loaded from api")
                return
            }
            self.categories = result
            self.categoriesCollectionView.reloadData()
            if result.count == 0 {
                showAlert(self, WARNING, ZERO_ITEMS_TO_OFFER)
            }
        }
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
            cell.categoryImage.image = UIImage.init(data: data)
        }
        return cell
    }
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WholeSalerShowDemand" {
            let vc = segue.destination as! WholeSalerListToMakeOfferViewController
            if let itemesSelected: [IndexPath] = self.categoriesCollectionView.indexPathsForSelectedItems {
                let categoryWithFamilyCount = self.categories[itemesSelected[0].item]
                vc.category = Category(id: categoryWithFamilyCount.id, name: categoryWithFamilyCount.name , image: categoryWithFamilyCount.image , totalFamilies: categoryWithFamilyCount.familyCount)
//                    Category(id: categoryWithFamilyCount.id, name: categoryWithFamilyCount.name, image: categoryWithFamilyCount.image)
            }
        }
    }
}
