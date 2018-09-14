import UIKit

class WholeSalerCreateListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnSaveHeight: NSLayoutConstraint!
    
    var categories = [Category]()
    
    var categoriesToAdd = [String]()
    var defaultCheckedCategories = [AddedCategory]()
    var editPressed:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        setupUI()
        loadCategoriesFromApi()
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfFamilyAlreadyAddedInCategory), name: Notification.Name("updateAddedCategoryCheckBox"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfFamilyAlreadyAddedInCategory()
    }
    
    // MARK: UI
    func setupUI()
    {
        title = "Crear lista"
        
        // CollectionView settings
        let layaout = self.categoriesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layaout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
        
//        self.btnSaveHeight.constant = 0
//        self.btnSave.isHidden = true
    }
    
    // MARK: API
    func loadCategoriesFromApi()
    {
        ApiService.instance.getCategories { (result) in
            guard let result: [Category] = result as? [Category]
                else {
                    print("NO Categories were loaded from api")
                    return
            }
            self.categories = result
            self.categories.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.categoriesCollectionView.reloadData()
        }
    }
    
    @objc func checkIfFamilyAlreadyAddedInCategory()
    {
        if loadUser().id == nil
        {
            
        }
        else
        {
            ApiService.instance.getAddedCategories(wholesalerId: loadUser().id) { (result) in
                
                guard let result: [AddedCategory] = result as? [AddedCategory] else {
                    print("Error while fetching added Categories response")
                    return
                }
                
                self.defaultCheckedCategories = result
                self.defaultCheckedCategories.remove(at: 0)
                self.categoriesCollectionView.reloadData()
            }
        }
    }
//    @objc func editPressed(sender: UIButton)
//    {
//        if sender.isSelected == true
//        {
//            self.editPressed = false
//            self.btnSaveHeight.constant = 0
//            self.btnSave.isHidden = true
//            sender.isSelected = false
//            self.categoriesToAdd.removeAll()
//        }
//        else
//        {
//            self.editPressed = true
//            self.btnSaveHeight.constant = 40
//            self.btnSave.isHidden = false
//            sender.isSelected = true
//        }
//        self.categoriesCollectionView.reloadData()
//    }
    
    @objc func selectDeselect(sender: UIButton)
    {
        let cell = self.categoriesCollectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! CategoryCollectionViewCell

        if sender.isSelected == true
        {
            let categoryId = String(self.categories[sender.tag].id)
            if self.categoriesToAdd.contains(categoryId)
            {
                let indexOf = self.categoriesToAdd.index(of: categoryId)
                self.categoriesToAdd.remove(at: indexOf!)
                print(self.categoriesToAdd)
                sender.isSelected = false
                cell.btnselect.setImage(UIImage(named: "Uncheckedbox"), for: .normal)
            }
        }
        else
        {
            sender.isSelected = true
            cell.btnselect.setImage(UIImage(named: "Checkedbox"), for: .selected)
            self.categoriesToAdd.append(String(self.categories[sender.tag].id))
            print(self.categoriesToAdd)
        }
    }
    
    @IBAction func btnAcceptPressed(_ sender: UIButton)
    {
        self.activityIndicator.startAnimating()
        
        var param = [String:Any]()
        
        let categoryIds = self.categoriesToAdd.joined(separator: ",")
        
        if loadCredentials().typeUser == .WHOLESALER
        {
            param["wholesalerId"] = loadUser().hiddenId
            param["categoryIds"] = categoryIds
        }
        
        print(param)
        
        ApiService.instance.addCategoryList(body: param, completion: { result in
            
            if result == nil
            {
                self.activityIndicator.stopAnimating()
                print("Failed to add category list")
            }
            self.activityIndicator.stopAnimating()
            self.categoriesToAdd.removeAll()

            self.checkIfFamilyAlreadyAddedInCategory()
        })
        
    }
    
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.item]
        
        cell.btnselect.isSelected = false
        
        cell.btnselect.setImage(UIImage(named: "Uncheckedbox"), for: .normal)
        cell.btnselect.setImage(UIImage(named: "Checkedbox"), for: .selected)
        
        cell.categoryName.text = category.name
        
        cell.lblFamilyCounter.isHidden = true
        
        cell.btnselect.tag = indexPath.item
        cell.btnselect.addTarget(self, action: #selector(selectDeselect(sender:)), for: .touchUpInside)
        
        let categoryId = String(category.id)
        if self.categoriesToAdd.contains(categoryId)
        {
            cell.btnselect.isSelected = true
        }
        
        if defaultCheckedCategories.count > 0
        {
            let checkedCategory = self.defaultCheckedCategories[indexPath.row]
            if checkedCategory.totalSelectedFamilies > 0
            {
                cell.btnselect.isSelected = true
            }
        }
        
//        if self.editPressed == true && FamilyCounter != 0
//        {
//            cell.btnselect.isHidden = false
//            cell.btnselect.setImage(UIImage(named: "Uncheckedbox"), for: .normal)
//        }
//        else
//        {
//            cell.btnselect.isHidden = true
//        }
        
//        ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
//            guard let data: Data = data as? Data else {
//                print("NO category image were loaded from api")
//                return
//            }
//
//            let image = UIImage.init(data: data)
//            let resizedImage = GlobalData.sharedInstance.resizedImage(withImage: image!, scaledTonewSize: CGSize(width: 150.0, height: 150.0))
//            cell.categoryImage.image = resizedImage//UIImage.init(data: data)
//        }
        
        cell.categoryImage.sd_setShowActivityIndicatorView(true)
        cell.categoryImage.sd_setIndicatorStyle(.gray)
        print(category.image)
        cell.categoryImage.sd_setImage(with: URL(string: "\(URL_CATEGORIES_IMAGE)/\(category.image)"), placeholderImage: nil, options: .refreshCached, completed: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let widthHeight = (UIScreen.main.bounds.size.width - 40) / 3
        return CGSize(width: widthHeight, height: widthHeight + 20.0)
    }

    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == WHOLESALER_SHOW_LISTS
        {
            let vc = segue.destination as! WholeSalerShowListsViewController
            if let itemesSelected: [IndexPath] = self.categoriesCollectionView.indexPathsForSelectedItems
            {
                vc.category = self.categories[itemesSelected[0].item]
            }
        }
    }
    
}
