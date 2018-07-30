//
//  ThankYouForShareViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 30/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ThankYouForShareViewController: UIViewController {
    
    
    @IBOutlet weak var lblMessage: UILabel!
    
    var strMessage:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblMessage.text = strMessage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IB Action Methods
    
    @IBAction func btnGoToHomeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
