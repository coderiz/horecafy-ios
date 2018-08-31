//
//  ProvinceListPopupVC.swift
//  horecafy
//
//  Created by aipxperts on 17/08/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ProvinceListPopupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tblvwProvinceList: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var stateList = [ProvinceData]()
    private var stateListSelected = [String]()
    
    var isFrom = ""
    var textFieldValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if textFieldValue.count > 0 && isFrom == "EditAccount"
        {
            stateListSelected = self.textFieldValue.trimmingCharacters(in: CharacterSet.whitespaces).components(separatedBy: ",")
        }
        else if textFieldValue.count > 0 && isFrom == "CreateAccount"
        {
            stateListSelected = self.textFieldValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        }
    }
    
    @objc func selectDeselect(sender: UIButton)
    {
        if sender.isSelected == true
        {
            let province = self.stateList[sender.tag].province
            if self.stateListSelected.contains(province)
            {
                let indexOf = self.stateListSelected.index(of: province)
                self.stateListSelected.remove(at: indexOf!)
                print(self.stateListSelected)
            }
        }
        else
        {
            self.stateListSelected.append(String(self.stateList[sender.tag].province))
            print(self.stateListSelected)
        }
        
        self.tblvwProvinceList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvinceListCell") as! ProvinceListCell
        
        cell.btnSelectProvince.tag = indexPath.row
        cell.btnSelectProvince.isSelected = false
        cell.btnSelectProvince.addTarget(self, action: #selector(selectDeselect), for: .touchUpInside)

        cell.lblProvince.text = self.stateList[indexPath.row].province
        
        let province = self.stateList[indexPath.row].province
        
        if self.stateListSelected.count > 0
        {
            if stateListSelected.contains(province)
            {
                cell.btnSelectProvince.isSelected = true
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    @IBAction func btnCancelTapped(sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAcceptTapped(sender: UIButton)
    {
        let provinceString = self.stateListSelected.joined(separator: ",")
        let finalString = provinceString.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if isFrom == "CreateAccount"
        {
            NotificationCenter.default.post(name: Notification.Name("selectedProvinces"), object: provinceString)
        }
        else if isFrom == "EditAccount" 
        {
            NotificationCenter.default.post(name: Notification.Name("selectProvincesInEdit"), object: provinceString)
        }
        
        self.dismiss(animated: true, completion: nil)
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
