//
//  BussinessRequirementFormViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class BussinessRequirementFormViewController: BaseViewController {

    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtRestaurantType: UITextField!
    @IBOutlet weak var txtComments: UITextView!
    @IBOutlet var RestaurantTypePicker: UIPickerView!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    var typeOfBusiness = [TypeOfBusiness]()
    var typeOfBusinessSelected: TypeOfBusiness?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.getBusinessTypes()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //IBAction Methods
    
    @IBAction func btnSelectRestaurantType(_ sender: Any) {
        self.txtRestaurantType.becomeFirstResponder()
        
    }
    
    @IBAction func btnSendPropasal(_ sender: Any) {
        self.view.endEditing(true)
        self.loading.startAnimating()
        if let BusinessPraposalReq = self.BussinessPraposalRequest() {
            ApiService.instance.SendPraposal(Praposal: BusinessPraposalReq, completion: { (response) in
                self.loading.stopAnimating()
                guard let ResponseforPraposal:BusinessPraposalResponse = response as? BusinessPraposalResponse else {
                    showAlert(self, ERROR, FAILURE_TO_SEND_PRAPOSAL)
                    return
                }
                
                if ResponseforPraposal.totalRows != 0 {
                    self.txtRestaurantType.text = ""
                    self.txtZipcode.text = ""
                    self.txtComments.text = ""
                    self.typeOfBusinessSelected = nil
//                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            })
        
        
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


//MARK:- Private Methods

extension BussinessRequirementFormViewController {
    
    func setLayout() {
        
//        self.title = "hacer un pedido"
        self.loading.hidesWhenStopped = true
        self.txtComments.layer.cornerRadius  = 5.0
        self.txtComments.layer.borderColor = UIColor.lightGray.cgColor
        self.txtComments.layer.borderWidth = 1.0
        self.txtComments.layer.masksToBounds = true
        self.txtRestaurantType.tag = 55555
        self.RestaurantTypePicker.translatesAutoresizingMaskIntoConstraints = false
        self.txtRestaurantType.inputView = self.RestaurantTypePicker
        self.txtRestaurantType.setDropDownButton()
        self.loading.hidesWhenStopped = true
        
    }
    
    func BussinessPraposalRequest() -> BusinessPraposal? {
        
//        guard let RestaurantZipcode = self.txtZipcode.text, self.txtZipcode.text != "" else {
//                showAlert(self, WARNING, missing)
//                return nil
//            }
    
        guard let typeOfBusiness = typeOfBusinessSelected else {
            showAlert(self, WARNING, MISSING_RESTAURANT_TYPE)
            return nil
        }
        
        guard let Comment = self.txtComments.text, self.txtComments.text != "" else {
            showAlert(self, WARNING, MISSING_DELIVERY_DATE)
            return nil
        }
 
        let MakeSendPraposal = BusinessPraposal(WholesalerId: Int(userId), typeOfBusinessId:  typeOfBusiness.id , comments: Comment, zipcode: (self.txtZipcode.text != "" ? self.txtZipcode.text! : ""))
        
        return MakeSendPraposal
    }
    
    func getBusinessTypes(){
        self.loading.startAnimating()
        ApiService.instance.getTypeOfBusiness { (result) in
            self.loading.stopAnimating()
            guard let result: [TypeOfBusiness] = result as? [TypeOfBusiness] else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            self.typeOfBusiness = result
            self.typeOfBusiness.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.RestaurantTypePicker.reloadAllComponents()
        }
    }
    
}

//MARK:- UIPickerview Datasource & Delegate Methods

extension BussinessRequirementFormViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.typeOfBusiness.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return  self.typeOfBusiness[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeOfBusinessSelected = typeOfBusiness[row]
        txtRestaurantType.text = self.typeOfBusinessSelected?.name
        
//        self.selectedDistributorId = self.arrDistributors[row].hiddenId
    }
}


