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
            AcceptCell.btnAccept.tag = indexPath.row
            AcceptCell.btnReject.tag = indexPath.row
            AcceptCell.AcceptCellDelegate = self
            tblcell = AcceptCell
        }
        else if NotificationObject.status == true {
            let DetailCell = self.tblNotificationView.dequeueReusableCell(withIdentifier: "CustomerNotificationDetailTblCell") as! CustomerNotificationDetailTblCell
            DetailCell.lblRestaurantName.text = NotificationObject.Wholesaler.name
            DetailCell.lblResaurantDesc.text = NotificationObject.comments
            if NotificationObject.timeslot != nil {
                DetailCell.lblTime.isHidden = false
                DetailCell.lblTime.text = NotificationObject.timeslot
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
}


//MARK:- Private Methods

extension CustomerBussinessNotificationViewController {
    
    func setLayot() {
        self.tblNotificationView.tableFooterView = UIView()
    }
    
    func getBusinessNotifications(){
        self.loading.startAnimating()
        
        let customerID = loadUser().id
        ApiService.instance.getCustomerBusinessNotification(CustomerId: customerID) { (result) in
            self.loading.stopAnimating()
            guard let result: [BusinessNotification] = result as? [BusinessNotification] else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            self.arrNotifications = result
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
        
    }
    
    func AcceptRequest(BtnIndex: Int) {
        
        let NotificationID = self.arrNotifications[BtnIndex].id
        self.Accept_RejectPraposal(isAccept: true, NotificationID: NotificationID)
    
    }
}
