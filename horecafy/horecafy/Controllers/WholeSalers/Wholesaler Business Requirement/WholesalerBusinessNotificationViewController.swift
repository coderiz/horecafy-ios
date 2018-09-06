//
//  WholesalerBusinessNotificationViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class WholesalerBusinessNotificationViewController: BaseViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var tblNotificationView: UITableView!
    
    var arrNotifications:[BusinessNotification] = []
    
    @IBOutlet var TimeSlotPickerView: UIPickerView!
    @IBOutlet var visitDatePickerView: UIPickerView!
    
    @IBOutlet weak var lblNoData: UILabel!
    
    var txtSetTime:UITextField!
    var arrAvailibility:[String] = []
    
    var txtSelectDate:UITextField!
    var arrDates:[String] = []
    
    var arrDaysTimeToBeShown:[String] = []

    var onlyDayNameInTimeSlot:[String] = []
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblNotificationView.tableFooterView = UIView()
        
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
extension WholesalerBusinessNotificationViewController : UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tblcell = UITableViewCell()
        let NotificationObject:BusinessNotification = self.arrNotifications[indexPath.row]
        
        if NotificationObject.timeslot != "" {
            let DetailCell = self.tblNotificationView.dequeueReusableCell(withIdentifier: "WholesalerNotificationDetailTblCell") as! WholesalerNotificationDetailTblCell
            DetailCell.lblRestaurantName.text = NotificationObject.Customer.name
            
            DetailCell.lblResaurantDesc.text = NotificationObject.comments
            
            if NotificationObject.images != ""
            {
                DetailCell.btnPreviewImages.isHidden = false
                DetailCell.btnPreviewImages.row = indexPath.row
                DetailCell.btnPreviewImages.section = indexPath.section
                DetailCell.btnPreviewImages.addTarget(self, action: #selector(previewImage(sender:)), for: .touchUpInside)
            }
            else
            {
                DetailCell.btnPreviewImages.isHidden = true
            }
            
            if NotificationObject.video != ""
            {
                DetailCell.btnPreviewVideo.isHidden = false
                DetailCell.btnPreviewVideo.row = indexPath.row
                DetailCell.btnPreviewVideo.section = indexPath.section
                DetailCell.btnPreviewVideo.addTarget(self, action: #selector(previewVideo(sender:)), for: .touchUpInside)
            }
            else
            {
                DetailCell.btnPreviewVideo.isHidden = true
            }
            
            let date = self.getDateFromString(date: NotificationObject.visitDate!)
            let timeSlot = self.getTimeSlot(timeslot: NotificationObject.timeslot!)
            let timeDate = date + " " + timeSlot
            
            DetailCell.lblTime.text = timeDate//"\(NotificationObject.visitDate) \(NotificationObject.timeslot)"
            tblcell = DetailCell
        }
        else {
            let AcceptCell = self.tblNotificationView.dequeueReusableCell(withIdentifier: "WholesalerAcceptTblCell") as! WholesalerAcceptTblCell
            AcceptCell.lblRestaurantName.text = NotificationObject.Customer.name
            
            AcceptCell.lblResaurantDesc.text = NotificationObject.comments
            
            if NotificationObject.images != ""
            {
                AcceptCell.btnPreviewImages.isHidden = false
                AcceptCell.btnPreviewImages.row = indexPath.row
                AcceptCell.btnPreviewImages.section = indexPath.section
                AcceptCell.btnPreviewImages.addTarget(self, action: #selector(previewImage(sender:)), for: .touchUpInside)
            }
            else
            {
                AcceptCell.btnPreviewImages.isHidden = true
            }
            
            if NotificationObject.video != ""
            {
                AcceptCell.btnPreviewVideo.isHidden = false
                AcceptCell.btnPreviewVideo.row = indexPath.row
                AcceptCell.btnPreviewVideo.section = indexPath.section
                AcceptCell.btnPreviewVideo.addTarget(self, action: #selector(previewVideo(sender:)), for: .touchUpInside)
            }
            else
            {
                AcceptCell.btnPreviewVideo.isHidden = true
            }
            
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
    
    @objc func previewImage(sender: MyButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ShowPreviewPopupVC") as! ShowPreviewPopupVC
        
        let NotificationObject:BusinessNotification = self.arrNotifications[sender.row]
        if NotificationObject.images != ""
        {
            let images = NotificationObject.images
            let imageArr = images?.components(separatedBy: ",")
            VC.arrImages = imageArr!
        }
        VC.showImageVideo = "showImages"
        
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func previewVideo(sender: MyButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ShowPreviewPopupVC") as! ShowPreviewPopupVC
        
        let NotificationObject:BusinessNotification = self.arrNotifications[sender.row]
        if NotificationObject.video != ""
        {
            VC.strVideo = NotificationObject.video
        }
        VC.showImageVideo = "showVideo"
        
        self.present(VC, animated: true, completion: nil)
    }
    
    func getDateFromString(date: String) -> String
    {
      /*  let responseDate = date
        let prefixIndex = responseDate.index(of: "T")
        let dateString = responseDate.prefix(upTo: prefixIndex!) */
        
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dat = formatter.date(from: date)
        formatter.dateFormat = "dd-MM-yyyy"
        let strDate = formatter.string(from: dat!)
        
        return strDate
    }
    
    func getTimeSlot(timeslot: String) -> String
    {
        let responseString = timeslot
        let finalString = responseString.dropFirst(4)
        return String(finalString)
    }
}


//MARK:- Private Methods
extension WholesalerBusinessNotificationViewController {
    
    func setLayot() {
        self.lblNoData.isHidden = true
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
                self.lblNoData.isHidden = false
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            
            self.arrNotifications = result
            
            if self.arrNotifications.count == 0 {
                self.lblNoData.isHidden = false
            }
            else {
                self.lblNoData.isHidden = true
            }
            self.tblNotificationView.reloadData()
        }
    }
    
    func getDayNamesFromTimeSlot()
    {
        for availibilityString in self.arrDaysTimeToBeShown
        {
            let dayNameInAvailibilityArr = availibilityString.prefix(3)
            if !self.onlyDayNameInTimeSlot.contains(String(dayNameInAvailibilityArr))
            {
                self.onlyDayNameInTimeSlot.append(String(describing: dayNameInAvailibilityArr).lowercased())
            }
        }
    }
    
    func getDaysFromCurrentDate()
    {
        let calendar = Calendar(identifier: .gregorian)
        
        let formater = DateFormatter()
        
        var index = 0
        while index <= 30
        {
            let date = calendar.date(byAdding: .day, value: index, to: Date())
            
            formater.dateFormat = "yyyy-MM-dd"
            let dateString = formater.string(from: date!)
            
            formater.dateFormat = "EEE"
            let dayString = formater.string(from: date!)
            
            let spanishDayString = self.convertDayNamesToSpanish(dayName: dayString)
            
            let fullStringDate = spanishDayString + " " + dateString
            
            let fullStringDatePrefix = fullStringDate.prefix(3)
            
            if self.onlyDayNameInTimeSlot.contains(String(describing: fullStringDatePrefix))
            {
                self.arrDates.append(fullStringDate)
            }
            
            index += 1
        }
        if self.arrDates.count != 0
        {
            self.filterDays(dateString: self.arrDates.first!)
        }
    }
    
    func filterDays(dateString: String)
    {
        let dateStringPrefix = dateString.prefix(3)
        
//        self.arrAvailibility = []
        
        for availibilityString in self.arrDaysTimeToBeShown
        {
            if dateStringPrefix == availibilityString.prefix(3)
            {
                arrAvailibility.append(availibilityString.lowercased())
            }
        }
        self.TimeSlotPickerView.reloadAllComponents()
    }
    
    func convertDayNamesToSpanish(dayName: String) -> String
    {
        if dayName == "Mon"
        {
            return "lun"
        }
        else if dayName == "Tue"
        {
            return "mar"
        }
        else if dayName == "Wed"
        {
            return "mier"
        }
        else if dayName == "Thu"
        {
            return "jue"
        }
        else if dayName == "Fri"
        {
            return "vier"
        }
        else if dayName == "Sat"
        {
            return "sab"
        }
        else
        {
            return "dom"
        }
    }
    
    func OpenPopupToSetTime(ID:String) {
        
        alertController = UIAlertController(title: "Fijar tiempo", message: "", preferredStyle: .alert)
       
        alertController.addTextField(configurationHandler: { (textField) in
            textField.backgroundColor = UIColor.clear
            textField.tag = 66666
            textField.setDropDownButton()
            textField.delegate = self
            textField.inputView = self.visitDatePickerView
        })
        
        alertController.addTextField { (textField) in
            textField.backgroundColor = UIColor.clear
            textField.tag = 55555
            textField.setDropDownButton()
            textField.delegate = self
            textField.inputView = self.TimeSlotPickerView
        }

        let saveAction = UIAlertAction(title: "ENVIAR", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let txtvisitDate = self.alertController.textFields![0] as UITextField
            let txtTimeslot = self.alertController.textFields![1] as UITextField
            if txtTimeslot.text != "" && txtvisitDate.text != "" {
                
                let visitDate = txtvisitDate.text!
                let finalString = visitDate.dropFirst(4)//String(suffix(visitDate.utf16, visitDate.utf16.count - 4))
                
                self.SubmitTimeSlot(NotificationID: ID, TimeSlot: txtTimeslot.text!, visitDate: String(describing: finalString))
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
            
            guard let Availableresult: AvailibilityResponse = result as? AvailibilityResponse else {
                self.loading.stopAnimating()
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            
            if let resultData:Availibility = Availableresult.data {
                self.loading.stopAnimating()
                
                self.arrDaysTimeToBeShown = resultData.availability.components(separatedBy: ",")
                self.arrAvailibility = resultData.availability.components(separatedBy: ",")
                
                self.getDayNamesFromTimeSlot()
                self.getDaysFromCurrentDate()
                
                self.TimeSlotPickerView.reloadAllComponents()
            }
            self.OpenPopupToSetTime(ID: NotificationID)
        }
    }
    
    func SubmitTimeSlot(NotificationID:String, TimeSlot:String, visitDate:String) {
        self.loading.startAnimating()
        ApiService.instance.SetTimeSlot(NotificationID: NotificationID, TimeSlot: TimeSlot, visitDate: visitDate) { (response) in
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
    
}

//MARK:- UITextfieldDelegate Methods

extension WholesalerBusinessNotificationViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        let txtDate = self.alertController.textFields![0]
        let txtTime = self.alertController.textFields![1]

        if txtDate.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 && self.arrDates.count > 0 && self.arrAvailibility.count > 0
        {
            txtDate.text = self.arrDates[0]
            self.filterDays(dateString: self.arrDates[0])
            txtTime.text = self.arrAvailibility[0]
        }
        
        if self.arrAvailibility.count > 0 && txtTime.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0
        {
            txtTime.text = self.arrAvailibility[0]
        }
        return true
    }
    
}


//MARK:- UIPickerview Datasource & Delegate Methods

extension WholesalerBusinessNotificationViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.visitDatePickerView
        {
            return self.arrDates.count
        }
        else
        {
            return self.arrAvailibility.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.visitDatePickerView
        {
            return self.arrDates[row]
        }
        else
        {
            return self.arrAvailibility[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let txtDate = self.alertController.textFields![0]
        let txtTime = self.alertController.textFields![1]
        
        if pickerView == self.visitDatePickerView
        {
            txtDate.text = self.arrDates[row]
            
            self.filterDays(dateString: self.arrDates[row])
            
            if self.arrAvailibility.count != 0
            {
                txtTime.text = self.arrAvailibility[0]
            }
        }
        else
        {
            txtTime.text = self.arrAvailibility[row]
        }
    }
}

