//
//  ForgotPasswordViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 28/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var UserType:Int = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.UserType  = ApiService.instance.SelectedForgotUserType
        emailTF.delegate = self
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTF.text, emailTF.text != "" else {
            showAlert(self, WARNING, EMAIL_MISSING)
            return
        }
        
        loading.startAnimating()
        ApiService.instance.ForgotPassword(email: email, typeUser: self.UserType) { (response) in
            
            self.loading.stopAnimating()
            guard let user: [PasswordRecoveryDetail] = response as? [PasswordRecoveryDetail] else {
                showAlert(self, ERROR, LOGIN_FAILED)
                return
            }
            if user.count == 0 {
                showAlert(self, ERROR, LOGIN_FAILED)
                return
            }
            
            let ResetPage = self.storyboard?.instantiateViewController(withIdentifier: RESET_PASSWORD_SCREEN) as! ResetViewController
            ResetPage.UserEmail = self.emailTF.text!
            ResetPage.UserType = self.UserType
            self.navigationController?.pushViewController(ResetPage, animated: true)
            
            print("User -> \(user)")
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ForgotPasswordViewController : UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

}
