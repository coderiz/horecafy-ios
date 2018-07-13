
import UIKit

class MainWholeSalerViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLoggedIn {
            let credentials = loadCredentials()
            if credentials.typeUser == .CUSTOMER {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: INITIAL) as! InitialViewController
                self.present(vc, animated: true, completion: nil)
            }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: INITIAL_WHOLESALER) as! InitialWholeSalerViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func goLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: WHOLESALER_LOGIN) as! LoginWholeSalerViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func goCreateAccount(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: WHOLESALER_CREATE) as! WholeSalerCreateAccountViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
