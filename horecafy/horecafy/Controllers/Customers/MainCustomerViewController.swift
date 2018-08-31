//
//  MainCustomerViewController.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 11/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class MainCustomerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CUSTOMER_LOGIN) as! LoginCustomerViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goCreateAccount(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CUSTOMER_CREATE) as! CustomerCreateAccountViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
