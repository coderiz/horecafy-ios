//
//  FreeListThanksViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 27/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class FreeListThanksViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IB Action Methods
    
    @IBAction func btnGoToHomeAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
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
