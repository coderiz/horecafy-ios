//
//  SetTimeViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 05/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class SetTimeViewController: UIViewController {
    
    var customerID:String = ""
    
    var arrAvailibility:[String] = []
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var tblTimeSlot: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.getCustomerAvailibility()
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


//MARK:- Private Methods

extension SetTimeViewController {
    
    func setLayout() {
        self.tblTimeSlot.tableFooterView = UIView()
        self.loading.hidesWhenStopped = true
    }
    
    func getCustomerAvailibility(){
        self.loading.startAnimating()
        ApiService.instance.getCustomerAvailibility(CustomerId: customerID) { (result) in
            self.loading.stopAnimating()
            guard let Availableresult: AvailibilityResponse = result as? AvailibilityResponse else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            
            if let resultData:Availibility = Availableresult.data {
                self.arrAvailibility = resultData.availability.components(separatedBy: ",")
                self.tblTimeSlot.reloadData()
            }
            
        }
    }
    
    func MakeArrayFromString(JsonString:String) -> [String] {
        
        var arrFinal:[String] = []
        let tempArray = JsonString.components(separatedBy: ",")
        for tempObject in tempArray {
            let Finalstring = tempObject.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: " ", with: "")
            let removedleftBracket = Finalstring.replacingOccurrences(of: "{", with: "")
            let removedRightBracket = removedleftBracket.replacingOccurrences(of: "}", with: "")
            arrFinal.append(removedRightBracket)
        }
        return arrFinal
    }
    
    
}

//MARK:- UITableview Datasource & Delegate Methods

extension SetTimeViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAvailibility.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var TblCell = self.tblTimeSlot.dequeueReusableCell(withIdentifier: "Mycell")
        
        if TblCell == nil {
            TblCell = UITableViewCell(style: .default, reuseIdentifier: "Mycell")
        }
        
        TblCell?.textLabel?.text = self.arrAvailibility[indexPath.row]
        TblCell?.accessoryType = .checkmark
        
//        TblCell.isSelected
        
//        TblCell.selectionStyle = .none
        
        return TblCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
}
