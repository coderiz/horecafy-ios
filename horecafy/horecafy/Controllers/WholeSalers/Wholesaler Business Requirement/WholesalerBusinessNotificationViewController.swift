//
//  WholesalerBusinessNotificationViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class WholesalerBusinessNotificationViewController: BaseViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var tblNotificationView: UITableView!
    
    var arrNotifications:[BusinessNotification] = []
    
    @IBOutlet var TimeSlotPickerView: UIPickerView!
    
    var txtSetTime:UITextField!
    var arrAvailibility:[String] = []
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayot()
        self.getBusinessNotifications()
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

}



//MARK:- UITableview Datasource & Delegate Methods

extension WholesalerBusinessNotificationViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tblcell = UITableViewCell()
        let NotificationObject:BusinessNotification = self.arrNotifications[indexPath.row]
        
        if NotificationObject.timeslot != nil {
            let DetailCell = self.tblNotificationView.dequeueReusableCell(withIdentifier: "WholesalerNotificationDetailTblCell") as! WholesalerNotificationDetailTblCell
            DetailCell.lblRestaurantName.text = NotificationObject.Customer.name
            
            DetailCell.lblResaurantDesc.text = NotificationObject.comments
            DetailCell.lblTime.text = NotificationObject.timeslot
            tblcell = DetailCell
        }
        else {
            let AcceptCell = self.tblNotificationView.dequeueReusableCell(withIdentifier: "WholesalerAcceptTblCell") as! WholesalerAcceptTblCell
            AcceptCell.lblRestaurantName.text = NotificationObject.Customer.name
            
            AcceptCell.lblResaurantDesc.text = NotificationObject.comments
            AcceptCell.btnSetTime.tag = indexPath.row
            AcceptCell.AcceptCellDelegate = self
            tblcell = AcceptCell
           
        }
        tblcell.selectionStyle = .none
        return tblcell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154.0
    }
}


//MARK:- Private Methods

extension WholesalerBusinessNotificationViewController {
    
    func setLayot() {
        self.tblNotificationView.tableFooterView = UIView()
        self.loading.hidesWhenStopped = true
        self.TimeSlotPickerView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func getBusinessNotifications(){
        self.loading.startAnimating()
        
        let WholeSalerID = loadUser().id
        ApiService.instance.getWholeSalerBusinessNotification(wholesalerId: WholeSalerID) { (result) in
            self.loading.stopAnimating()
            guard let result: [BusinessNotification] = result as? [BusinessNotification] else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            self.arrNotifications = result
            self.tblNotificationView.reloadData()

        }
    }
    
    func OpenPopupToSetTime(ID:String) {
        
        alertController = UIAlertController(title: "Fijar tiempo", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.backgroundColor = UIColor.clear
            textField.tag = 55555
            textField.setDropDownButton()
            textField.inputView = self.TimeSlotPickerView
        }
        
//        txtSetTime = UITextField(frame: CGRect(x: 15, y: 5, width: UIScreen.main.bounds.size.width - 100, height: 100.0))
//        txtSetTime.backgroundColor = UIColor.clear
//        txtSetTime.tag = 55555
//        txtSetTime.setDropDownButton()
//        txtSetTime.inputView = TimeSlotPickerView
//        alertController.view.addSubview(txtSetTime)
//        alertController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 100, height: 200.0)
        let saveAction = UIAlertAction(title: "ENVIAR", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let textField = self.alertController.textFields![0] as UITextField
            if textField.text != "" {
                self.SubmitTimeSlot(NotificationID: ID, TimeSlot: textField.text!)
            }
        })
        
        let cancelAction = UIAlertAction(title: "CANCELAR", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    func getCustomerAvailibility(Customer_ID:String, NotificationID:String){
        self.loading.startAnimating()
        ApiService.instance.getCustomerAvailibility(CustomerId: Customer_ID) { (result) in
            self.loading.stopAnimating()
            guard let result: Availibility = result as? Availibility else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            
            self.arrAvailibility = result.availability.components(separatedBy: ",")
//                self.MakeArrayFromString(JsonString: result.availability)
            self.TimeSlotPickerView.reloadAllComponents()
            
            self.OpenPopupToSetTime(ID: NotificationID)
            
        }
    }
    
    func SubmitTimeSlot(NotificationID:String, TimeSlot:String) {
        self.loading.startAnimating()
        ApiService.instance.SetTimeSlot(NotificationID: NotificationID, TimeSlot: TimeSlot) { (response) in
            self.loading.stopAnimating()
            guard let ResponseforOrderRequest:SetTimeSlotResponse = response as? SetTimeSlotResponse else {
                showAlert(self, ERROR, FAILURE_TO_SUBMIT)
                return
            }
            
            if ResponseforOrderRequest.totalRows != 0 {
                self.getBusinessNotifications()
            }
        }

    }
    
    func MakeArrayFromString(JsonString:String) -> [String] {
        var arrFinal:[String] = []
        let tempArray = JsonString.components(separatedBy: ",")
        for tempObject in tempArray {
            let Finalstring = tempObject.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: " ", with: "")
            let removedleftBracket = Finalstring.replacingOccurrences(of: "{", with: "")
            let removedRightBracket = removedleftBracket.replacingOccurrences(of: "}", with: "")
            
        
            arrFinal.append(removedRightBracket)
        }
        return arrFinal
    }
}

extension WholesalerBusinessNotificationViewController : WholesalerAcceptCellDelegate {
    
    func SetTime(BtnIndex: Int) {
        let customerID = self.arrNotifications[BtnIndex].Customer.id
        self.getCustomerAvailibility(Customer_ID: customerID, NotificationID: self.arrNotifications[BtnIndex].id)
        
    }
    
//    func AcceptRequest(BtnIndex: Int) {
//
//    }
}


//MARK:- UIPickerview Datasource & Delegate Methods

extension WholesalerBusinessNotificationViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrAvailibility.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return  self.arrAvailibility[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.txtSetTime.text = self.arrAvailibility[row]
        let txtTime = self.alertController.textFields![0]
        txtTime.text = self.arrAvailibility[row]
        //        self.selectedDistributorId = self.arrDistributors[row].hiddenId
    }
}
