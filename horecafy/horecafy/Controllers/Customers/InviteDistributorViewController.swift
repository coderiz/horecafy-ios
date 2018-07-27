//
//  InviteDistributorViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class InviteDistributorViewController: BaseViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
//        Invitar a distribuidor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Mark:- IBAction Methods
    
    @IBAction func btnSendInvitation(_ sender: Any) {
        
        self.view.endEditing(true)
        if let MakeInvitation = self.MakeInvitationRequest() {
            
            self.loading.startAnimating()
            ApiService.instance.SendInvitation(Invitation: MakeInvitation, completion: { (response) in
                self.loading.stopAnimating()
                guard let ResponseforOrderRequest:InvitationResoponse = response as? InvitationResoponse else {
                    showAlert(self, ERROR, FAILURE_TO_SEND_INVITATION)
                    return
                }
                
                if ResponseforOrderRequest.totalRows != 0 {
                    if let WholesalerName:String = (self.txtName.text){
                    showAlert(self, SUCCESS, "Se ha enviado una invitacion a \(WholesalerName)", delegate: self)
                    }
                    
                }
            })
        }

    }
    
}


//MARK:- Private Methods

extension InviteDistributorViewController {
    
    func setLayout() {
        
        self.title = "Invitar a distribuidor"
        self.loading.hidesWhenStopped = true
        
        
    }
    
    private func MakeInvitationRequest() -> InviteDistributor? {
        
        
        guard let DistName = self.txtName.text, self.txtName.text != "" else {
            showAlert(self, WARNING, NAME_MISSING)
            return nil
        }
        guard let DistEmail = self.txtEmail.text, self.txtEmail.text != "" else {
            showAlert(self, WARNING, EMAIL_MISSING)
            return nil
        }
        guard let DistPhone = self.txtPhone.text, self.txtPhone.text != "" else {
            showAlert(self, WARNING, PHONE_MISSING)
            return nil
        }
        guard let DistContact = self.txtContact.text, self.txtContact.text != "" else {
            showAlert(self, WARNING, CONTACT_DATA_ERROR)
            return nil
        }
        
        
        let InvitationRequest = InviteDistributor(customerId: Int(userId), name: DistName, email: DistEmail, phone: DistPhone, contact: DistContact)
        return InvitationRequest
    }
    
    
}

//MARK:- Alertiview Delegate Method

extension InviteDistributorViewController : CustomerAlertView {
    
    func didTapInOkButtton(isSuccess: Bool) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

//MARK:- UITextfield Delegate Method

extension InviteDistributorViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var returnvalue:Bool = true
        
        if textField != self.txtPhone {
            let aSet = NSCharacterSet(charactersIn:"+-0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if string != numberFiltered {
                returnvalue = false
            }
        }
        return returnvalue
    }
}


