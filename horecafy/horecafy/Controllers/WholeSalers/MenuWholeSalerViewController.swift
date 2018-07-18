import UIKit

class MenuWholeSalerViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var WholeSalerMenuCollectionView: UICollectionView!
    
    
    
    var arrMenu:[String] = []
    var arrMenuImages:[String] = []
    
    override func viewDidLoad() {
        arrMenu = ["crea tus listas","Realiza ofertas", "Exporta solicitudes en fichero","Sube ofertas en fichero", "Visitas comerciales"]
        arrMenuImages = ["Create_Your_List","002-descuento","002-descargar-fichero-de-la-nube", "001-archivo-de-excel", "Commercial_Visits"]

        //        self.CustomerMenuCollectionView.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isLoggedIn {
            showLogin()
        }
    }
    
    func showLogin() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MAIN) as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapInEditButton(_ sender: Any) {
        if let editUserViewController = storyboard?.instantiateViewController(withIdentifier: "WholeSalerEditDataID") as? WholeSalerEditDataViewController {
            navigationController?.pushViewController(editUserViewController, animated: true)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        removeCredentials()
        removeUser()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MAIN) as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func downloadTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: UPLOAD_DOWNLOAD_SEGUE) as! UploadDownloadViewController
        vc.msg = "Ponte en contacto con nosotros y te exportaremos las demandas de tus horecas a un fichero!!!"
        vc.email = "distribuidores@horecafy.com"
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: UPLOAD_DOWNLOAD_SEGUE) as! UploadDownloadViewController
        vc.msg = "Ponte en contacto con nosotros para subir tu fichero de ofertas a nuestra base de datos!!!"
        vc.email = "distribuidores@horecafy.com"
        self.present(vc, animated: true, completion: nil)
    }
}

extension MenuWholeSalerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            self.performSegue(withIdentifier: WHOLESALER_CREATE_LIST_SEGUE, sender: nil)
        case 1:
            self.performSegue(withIdentifier: WHOLESALER_OFFER_SEGUE, sender: nil)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: UPLOAD_DOWNLOAD_SEGUE) as! UploadDownloadViewController
            vc.msg = "Ponte en contacto con nosotros y te exportaremos las demandas de tus horecas a un fichero!!!"
            vc.email = "distribuidores@horecafy.com"
            self.present(vc, animated: true, completion: nil)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: UPLOAD_DOWNLOAD_SEGUE) as! UploadDownloadViewController
            vc.msg = "Ponte en contacto con nosotros para subir tu fichero de ofertas a nuestra base de datos!!!"
            vc.email = "distribuidores@horecafy.com"
            self.present(vc, animated: true, completion: nil)
        case 4:
            self.performSegue(withIdentifier: WHOLESALER_BUSINESS_VISIT_SEGUE , sender: nil)
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

