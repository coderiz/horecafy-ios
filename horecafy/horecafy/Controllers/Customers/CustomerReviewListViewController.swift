import UIKit

class CustomerReviewListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var categories = [CategoryWithFamilyCount]()
    private let collectionViewBackground = UIView.initFromXib(CollectionViewBackground.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activityIndicator.startAnimating()
        let credentials = loadCredentials()
        ApiService().fetchOffers(userID: credentials.userId) { result in
            self.activityIndicator.stopAnimating()
            guard let categories = result as? [CategoryWithFamilyCount] else {
                return
            }
            self.categories = categories
            if self.categories.isEmpty {
                self.collectionView.backgroundView = self.collectionViewBackground
            } 
            self.collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        title = "Revisar Oferta"
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layaout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layaout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? CustomerShareCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        cell.numberOfRequests.text = category.familyCount == 1 ? "\(category.familyCount) solicitud" : "\(category.familyCount) solicitudes"
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
        if segue.identifier == "CustomerListToMakeOfferSegue" {
            if let vc = segue.destination as? CustomerListToMakeOfferViewController, let itemesSelected = self.collectionView.indexPathsForSelectedItems  {
                let categoryWithFamilyCount = self.categories[itemesSelected[0].item]
                vc.category = Category(id: categoryWithFamilyCount.id, name: categoryWithFamilyCount.name, image: categoryWithFamilyCount.image, totalFamilies: categoryWithFamilyCount.familyCount)
//                    Category(id: categoryWithFamilyCount.id, name: categoryWithFamilyCount.name, image: categoryWithFamilyCount.image)
            }
        }
    }
}

