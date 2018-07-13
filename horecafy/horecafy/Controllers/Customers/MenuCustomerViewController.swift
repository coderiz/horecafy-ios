import UIKit

class MenuCustomerViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menu1BackGround: UIView!
    @IBOutlet weak var menu2BackGround: UIView!
    @IBOutlet weak var menu3BackGround: UIView!
    
    @IBOutlet weak var CustomerMenuCollectionView: UICollectionView!
    
    var arrMenu:[String] = []
    var arrMenuImages:[String] = []
    
    
    override func viewDidLoad() {
        arrMenu = ["crea tus listas","Comparte tus listas","Revisa ofertas", "Buscar productos", "hacer un pedido", "Visitas comerciales", "Revisar ofertas"]
        arrMenuImages = ["Create_Your_List","Share_To_Lists","Check_Offers","Find_Products","Make_An_Order","Commercial_Visits","icon_Review"]
        //        self.CustomerMenuCollectionView.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    func showLogin() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MAIN) as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
    //MARK: Actions
    @IBAction func didTapInEditButton(_ sender: Any) {
        if let editUserViewController = storyboard?.instantiateViewController(withIdentifier: "CustomerEditDataID") as? CustomerEditDataViewController {
            navigationController?.pushViewController(editUserViewController, animated: true)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        removeCredentials()
        removeUser()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MAIN) as! MainViewController
        self.present(vc, animated: true, completion: nil)
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

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            self.performSegue(withIdentifier: CUSTOMER_CREATE_LIST, sender: nil)
        case 1:
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
        case 2:
            self.performSegue(withIdentifier: CUSTOMER_REVIEW_LIST, sender: nil)
        
        case 3:
            self.performSegue(withIdentifier: CUSTOMER_BUSSINESS_REQUEST_SEGUE, sender: nil)
        
        case 4:
            self.performSegue(withIdentifier: MAKE_AN_ORDER_SEGUE, sender: nil)
            
        case 5:
            self.performSegue(withIdentifier: CUSTOMER_BUSINESS_VISIT_SEGUE, sender: nil)
        
        case 6:
            self.performSegue(withIdentifier: REVIEW_OFFERS_SEGUE, sender: nil)
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthHeight = (UIScreen.main.bounds.size.width - 40) / 3
        //            ([[UIScreen mainScreen]bounds].size.width / 3 ) - 18;
        
        return CGSize(width: widthHeight, height: widthHeight + 50.0)
    }

    
}
