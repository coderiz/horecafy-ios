import UIKit

class MenuCustomerViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menu1BackGround: UIView!
    @IBOutlet weak var menu2BackGround: UIView!
    @IBOutlet weak var menu3BackGround: UIView!
    
    @IBOutlet weak var CustomerMenuCollectionView: UICollectionView!
    
    var arrMenu:[String] = []
    var arrMenuImages:[String] = []
    
    var offerCount = 0
    var visitCount = 0
    
    override func viewDidLoad() {
        arrMenu = ["crea tus listas","Compartir listas","Revisar ofertas", "Buscar productos", "Visitas comerciales", "hacer un pedido"]
        arrMenuImages = ["Create_Your_List","Share_To_Lists","icon_Review","Find_Products","Commercial_Visits","Make_An_Order"]
        //        self.CustomerMenuCollectionView.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        
        if !isLoggedIn {
            showLogin()
        }
        else {
            let credentials = loadCredentials()
            if credentials.typeUser == .WHOLESALER {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: INITIAL_WHOLESALER) as! InitialWholeSalerViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.getMenuIconsLabelCount()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getMenuIconsLabelCount), name: Notification.Name("UpdateCustomerVisitCommercialsCount"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getMenuIconsLabelCount()
    }
    
    func showLogin() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MAIN) as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func getMenuIconsLabelCount() {
        
        if loadCredentials().typeUser == .CUSTOMER
        {
            let customerID = loadUser().id
            
            ApiService.getCustomerMenuIconsLabelCount(customerId: customerID) { (result) in
                
                guard let result: customerStats = result as? customerStats else
                {
                    print("No stats loaded from api")
                    return
                }
                
                self.offerCount = result.totalPendingOffers
                self.visitCount = result.totalPendingVisits
                
                self.CustomerMenuCollectionView.reloadData()
            }
        }
        
    }
    
    //MARK: Actions
    @IBAction func didTapInEditButton(_ sender: Any) {
        if let editUserViewController = storyboard?.instantiateViewController(withIdentifier: "CustomerEditDataID") as? CustomerEditDataViewController {
            navigationController?.pushViewController(editUserViewController, animated: true)
        }
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        let alert = UIAlertController(title: "horecafy", message: "¿Realmente quieres desconectarte?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Sí", style: .default, handler: { action in
            removeCredentials()
            removeUser()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: MAIN) as! MainViewController
            self.present(vc, animated: true, completion: nil)
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapInCustomerListsButton(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerShareListViewControllerID") as? CustomerShareListViewController {
            let credentials = loadCredentials()
            activityIndicator.startAnimating()
            ApiService.instance.getCategoriesDemandWithFamilyCount(customerId: credentials.userId) { (result) in
                self.activityIndicator.stopAnimating()
                guard let result: [CategoryWithFamilyCount] = result as? [CategoryWithFamilyCount] else {
                    self.showListAlert()
                    return
                }
                if result.isEmpty {
                    self.showListAlert()
                }
                vc.categories = result
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func showListAlert() {
        showAlert(self, "Información", "No hay listas para compartir. Crea tus listas primero")
    }
}

extension MenuCustomerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.arrMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenuCell", for: indexPath) as! HomeMenuCell
        cell.imgMenu.image = UIImage(named: self.arrMenuImages[indexPath.item])
        cell.lblMenuName.text = self.arrMenu[indexPath.item]

        
        if indexPath.item == 0
        {
            cell.lblCount.isHidden = true
        }
        else if indexPath.item == 1
        {
            cell.lblCount.isHidden = true
        }
        else if indexPath.item == 2
        {
            if self.offerCount == 0
            {
                cell.lblCount.isHidden = true
            }
            else
            {
                cell.lblCount.isHidden = false
                cell.lblCount.text = "\(self.offerCount)"
            }
        }
        else if indexPath.item == 3
        {
            cell.lblCount.isHidden = true
        }
        else if indexPath.item == 4
        {
            if self.visitCount == 0
            {
                cell.lblCount.isHidden = true
            }
            else
            {
                cell.lblCount.isHidden = false
                cell.lblCount.text = "\(self.visitCount)"
            }
        }
        else if indexPath.item == 5
        {
            cell.lblCount.isHidden = true
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            self.performSegue(withIdentifier: CUSTOMER_CREATE_LIST, sender: nil)
        case 1:
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerShareListViewControllerID") as! CustomerShareListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
//            self.performSegue(withIdentifier: CUSTOMER_REVIEW_LIST, sender: nil)
            self.performSegue(withIdentifier: REVIEW_OFFERS_SEGUE, sender: nil)
        case 3:
            self.performSegue(withIdentifier: CUSTOMER_BUSSINESS_REQUEST_SEGUE, sender: nil)
        
        case 4:
            self.performSegue(withIdentifier: CUSTOMER_BUSINESS_VISIT_SEGUE, sender: nil)
            
        case 5:
            self.performSegue(withIdentifier: MAKE_AN_ORDER_SEGUE, sender: nil)
        
//        case 6:
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthHeight = (UIScreen.main.bounds.size.width - 20) / 2
        //            ([[UIScreen mainScreen]bounds].size.width / 3 ) - 18;
        
        return CGSize(width: widthHeight, height: widthHeight)
    }

    
}
