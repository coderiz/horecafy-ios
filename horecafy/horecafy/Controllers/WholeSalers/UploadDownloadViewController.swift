//
//  UploadDownloadViewController.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 3/3/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class UploadDownloadViewController: UIViewController {

    var msg: String = ""
    var email: String = ""
    @IBOutlet weak var mensaje: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mensaje.text = msg
        self.emailLabel.text = email
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
