//
//  CustomerBussinessReqViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 29/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class CustomerBussinessReqViewController: BaseViewController {
    
    
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var brand: UITextField!
    
    @IBOutlet weak var quantyOfMonth: UITextField!
    
    @IBOutlet weak var targetPrice: UITextField!
    
    @IBOutlet weak var btnYes: UIButton!
    
    @IBOutlet weak var btnNo: UIButton!
    
    var SelectedOption:Int = -1
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.view.endEditing(true)
        if let customerRequest = BusinessRequest() {
            
            self.loading.startAnimating()
            ApiService.instance.createCustomerBusinessRequest(BusinessRequest: customerRequest, completion: { (response) in
                self.loading.stopAnimating()
                guard let ResponseForBusinessRequest:BusinessRequestResponse = response as? BusinessRequestResponse else {
//                    showAlert(self, ERROR, CUSTOMER_CREATE_DEMAND_FAILED)
                    return
                }
                
                if ResponseForBusinessRequest.totalRows != 0 {
                    self.performSegue(withIdentifier: THANKS_BUSINESS_REQUEST_SEGUE, sender: nil)
                }
            })
        }
        
        
    }
    
    
    @IBAction func btnYesNoAction(_ sender: UIButton) {
        
        self.btnNo.isSelected = false
        self.btnYes.isSelected = false
        
        if sender == self.btnNo {
            self.SelectedOption = 1
            self.btnNo.isSelected = true
        }
        else if sender == self.btnYes {
            self.SelectedOption = 0
            self.btnYes.isSelected = true
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



extension CustomerBussinessReqViewController {
    
    func setLayout() {
        self.SelectedOption = 1
        
        if self.SelectedOption == 0 {
            self.btnYes.isSelected = true
        }
        else if self.SelectedOption == 1 {
            self.btnNo.isSelected = true
        }
        
        self.title = "Buscar productos"
        self.loading.hidesWhenStopped = true
        self.txtDescription.layer.cornerRadius  = 5.0
        self.txtDescription.layer.borderColor = UIColor.lightGray.cgColor
        self.txtDescription.layer.borderWidth = 1.0
        self.txtDescription.layer.masksToBounds = true
        

    }
    
    private func BusinessRequest() -> CustomerBusinessRequest? {
        
        
        var sucessValue:String = ""
        if self.SelectedOption == 0 {
            sucessValue = "Yes"
        }
        else if self.SelectedOption == 1 {
            sucessValue = "No"
        }
        
        guard let productName = self.txtDescription.text, self.txtDescription.text != "" else {
            showAlert(self, WARNING, MISSING_PRODUCT_DESCRIPTION)
            return nil
        }
        
        guard let brand = self.brand.text, self.brand.text != "" else {
            showAlert(self, WARNING, BRAND_MISSING)
            return nil
        }
        
        guard let MonthConsumption = self.quantyOfMonth.text, self.quantyOfMonth.text != "" else {
            showAlert(self, WARNING, TARGET_PRICE_MISSING)
            return nil
        }
        
        guard let targetPrice = Double(self.targetPrice.text!), self.targetPrice.text != "" else {
            showAlert(self, WARNING, TARGET_PRICE_MISSING)
            return nil
        }
       
        let Request = CustomerBusinessRequest(customerId: Int(userId), productName: productName, brand: brand, consumption: MonthConsumption, targetPrice: targetPrice, MailFlag: sucessValue)
        
        return Request
    }
    
    
}
