import UIKit

class LoginWholeSalerViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailTF.text, emailTF.text != "" else {
            showAlert(self, WARNING, EMAIL_MISSING)
            return
        }
        
        guard let password = passwordTF.text, passwordTF.text != "" else {
            showAlert(self, WARNING, PASSWORD_MISSING)
            return
        }
        
        if ApiService.instance.checkInternet() == false {
            showAlert(self,WARNING, NO_INTERNET)
            return
        }
        
        loading.startAnimating()
        ApiService.instance.loginUser(email: email, password: password, typeUser: TypeOfUser.WHOLESALER.rawValue) { (response) in
            
            self.loading.stopAnimating()
            guard let user: [User] = response as? [User] else {
                showAlert(self, ERROR, LOGIN_FAILED)
                return
            }
            
            if user.count == 0 {
                showAlert(self, ERROR, LOGIN_FAILED)
                return
            }
            
            print("User -> \(user)")
            
            storeCredentials(Credentials(userId: Int64(user[0].hiddenId)!, email: email, password: password, typeUser: TypeOfUser.WHOLESALER))
            if let userUnwrapped = user.first {
             storeUser(user: userUnwrapped)
            }
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func btnForgotAction(_ sender: Any) {
        
        let navController = self.storyboard?.instantiateViewController(withIdentifier: FORGOT_NAVIGATION) as!  UINavigationController
        ApiService.instance.SelectedForgotUserType = 0
        self.present(navController, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    override func keyboardWillAppear() {
        bottomConstraint.constant = 350
        reloadView()
    }
    
    override func keyboardWillDisappear() {
        bottomConstraint.constant = 0
        reloadView()
    }
}
