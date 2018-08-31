//
//  CustomerBussinessNotificationViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class CustomerBussinessNotificationViewController: UIViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var tblNotificationView: UITableView!
    
    @IBOutlet weak var lblNoData: UILabel!
    
    var arrNotifications:[BusinessNotification] = []
    
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

extension CustomerBussinessNotificationViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tblcell = UITableViewCell()
        let NotificationObject:BusinessNotification = self.arrNotifications[indexPath.row]
        
        if NotificationObject.status == false {
            let AcceptCell = self.tblNotificationView.dequeueReusableCell(withIdentifier: "CustomerAcceptTblCell") as! CustomerAcceptTblCell
            AcceptCell.lblRestaurantName.text = NotificationObject.Wholesaler.name
            
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
            
            AcceptCell.btnAccept.tag = indexPath.row
            AcceptCell.btnReject.tag = indexPath.row
            AcceptCell.AcceptCellDelegate = self
            tblcell = AcceptCell
        }
        else if NotificationObject.status == true {
            let DetailCell = self.tblNotificationView.dequeueReusableCell(withIdentifier: "CustomerNotificationDetailTblCell") as! CustomerNotificationDetailTblCell
            DetailCell.lblRestaurantName.text = NotificationObject.Wholesaler.name
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
            
            if NotificationObject.timeslot != nil && NotificationObject.visitDate != ""{
                
                let date = self.getDateFromString(date: NotificationObject.visitDate!)
                let timeSlot = self.getTimeSlot(timeslot: NotificationObject.timeslot!)
                let timeDate = date + " " + timeSlot
                
                DetailCell.lblTime.isHidden = false
                DetailCell.lblTime.text = timeDate//NotificationObject.timeslot
            }
            else {
                DetailCell.lblTime.isHidden = true
            }
            tblcell = DetailCell
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

extension CustomerBussinessNotificationViewController {
    
    func setLayot() {
         self.lblNoData.isHidden = true
        self.tblNotificationView.tableFooterView = UIView()
    }
    
    func getBusinessNotifications() {
        self.loading.startAnimating()
        
        let customerID = loadUser().id
        ApiService.instance.getCustomerBusinessNotification(CustomerId: customerID) { (result) in
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
    
    func Accept_RejectPraposal(isAccept:Bool, NotificationID:String) {
        self.loading.startAnimating()
        ApiService.instance.Accept_RejectBusinessPraposal(isAccept: isAccept, NotificationID: NotificationID) { (response) in
            self.loading.stopAnimating()
            guard let result: BusinessPraposalResponse = response as? BusinessPraposalResponse else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            
            if result.totalRows != 0 {
                self.getBusinessNotifications()
            }
        }
    }
    
}

extension CustomerBussinessNotificationViewController : CustomerAcceptCellDelegate {
    
    func RejectRequest(BtnIndex: Int) {
     
        let NotificationID = self.arrNotifications[BtnIndex].id
        self.Accept_RejectPraposal(isAccept: false, NotificationID: NotificationID)
        NotificationCenter.default.post(name: Notification.Name("UpdateCustomerVisitCommercialsCount"), object: nil)
    }
    
    func AcceptRequest(BtnIndex: Int) {
        
        let NotificationID = self.arrNotifications[BtnIndex].id
        self.Accept_RejectPraposal(isAccept: true, NotificationID: NotificationID)
        NotificationCenter.default.post(name: Notification.Name("UpdateCustomerVisitCommercialsCount"), object: nil)
    }
}
