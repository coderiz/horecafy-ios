//
//  ResetViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 28/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ResetViewController: BaseViewController {
    
    @IBOutlet weak var securityCodeTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var UserEmail:String = ""
    var UserType:Int = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        securityCodeTF.delegate = self
        passwordTF.delegate = self
        rePasswordTF.delegate = self
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        
        guard let securityCode = securityCodeTF.text?.removingSpacesAndNewLines, securityCodeTF.text != "" else {
            showAlert(self, WARNING, SECURY_PASSCODE_MISSING)
            return
        }
        
        guard let password = passwordTF.text?.removingSpacesAndNewLines, passwordTF.text != "" else {
            showAlert(self, WARNING, PASSWORD_MISSING)
            return
        }
        
        guard let repassword = rePasswordTF.text?.removingSpacesAndNewLines, rePasswordTF.text != "" else {
            showAlert(self, WARNING, RE_PASSWORD_MISSING)
            return
        }
        
        guard password == repassword else {
            showAlert(self, WARNING, PASSWORDS_ARE_NOT_EQUAL)
            return
        }

        loading.startAnimating()
        ApiService.instance.ResetPassword(email: UserEmail, typeUser: UserType, Token: securityCode, password: password) { (response) in
            
            self.loading.stopAnimating()
            guard let user: [User] = response as? [User] else {
                showAlert(self, ERROR, LOGIN_FAILED)
                return
            }
            if user.count == 0 {
                showAlert(self, ERROR, LOGIN_FAILED)
                return
            }
          
            self.navigationController?.dismiss(animated: true, completion: nil)
//            self.dismiss(animated: true, completion: nil)
        }
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

extension ResetViewController : UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

