//
//  CustomerCreateFreeListViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 26/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class CustomerCreateFreeListViewController: BaseViewController {

    @IBOutlet weak var tblCustomerCreateFreeList: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var arrCreateFreeList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loading.hidesWhenStopped = true
        
        self.SetLayout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IB Action Methods
    
    @objc func BtnAddInToListAction() {
        arrCreateFreeList.append("")
        self.tblCustomerCreateFreeList.reloadData()
    }
    
    
    @IBAction func btnAddFreeList(_ sender: Any) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.CreatFreeList()
        }
        
    }
    
    func CreatFreeList() {
        let arrFreeLIst = self.arrCreateFreeList.filter({ (response) -> Bool in
            return response != ""
        })
        
        if arrFreeLIst.count >= 0 {
           
//                list.filter { $0 != nil }
            let demandText:String = self.json(from: arrFreeLIst as Any) ?? ""
//                self.arrCreateFreeList.joined(separator: ",")
            let createFreeDemand = CreateFreeDemand(customerId: Int(userId), demandText: demandText)
            self.loading.startAnimating()
            ApiService.instance.createCustomerFreeDemand(FreeDemand: createFreeDemand, completion: { (response) in
                self.loading.stopAnimating()
                guard let ResponseFreeDemand:FreeDemandResponse = response as? FreeDemandResponse else {
//                    showAlert(self, ERROR, CUSTOMER_CREATE_DEMAND_FAILED)
                    return
                }
                
                if ResponseFreeDemand.totalRows != 0 {
                    self.arrCreateFreeList.removeAll()
                    self.arrCreateFreeList.append("")
                    self.tblCustomerCreateFreeList.reloadData()
                    self.performSegue(withIdentifier: FREE_LIST_THANK_YOU, sender: nil)
                }
            })
        }
        else {
            showAlert(self, ERROR, MISSING_FREE_LIST_ERROR)
        }
    }
    
    //UI Tableview
    
    
    // UI Textfield Delegate Methods
    // Delete Product Delegate Methods
    
    

    
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

extension CustomerCreateFreeListViewController {
    func SetLayout() {
        self.title = "crear Productos lista"
        self.tblCustomerCreateFreeList.tableFooterView = UIView()
        arrCreateFreeList.append("")
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

//MARK:- UITextfield Delegate Methods

extension CustomerCreateFreeListViewController : UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let TextFieldIndex = textField.tag
        let textSTring = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if textSTring != "" {
            self.arrCreateFreeList[TextFieldIndex] = textSTring!
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

//MARK:- Delete Product Delegate Methods

extension CustomerCreateFreeListViewController : btnDeleteProtocol {
    
    func BtnDeleteMethod(btnIndex: Int) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.deleteRow(Index: btnIndex)
        }
       
    }

    func deleteRow(Index:Int) {
        if self.arrCreateFreeList.count > 1 {
            self.arrCreateFreeList.remove(at: Index)
            self.tblCustomerCreateFreeList.reloadData()
        }
    }
    
}

//MARK:- UITableView Datasource & Delegate Methods

extension CustomerCreateFreeListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCreateFreeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let FreeListCell:CreateFreeListCell = self.tblCustomerCreateFreeList.dequeueReusableCell(withIdentifier: "CreateFreeListCell") as! CreateFreeListCell
        FreeListCell.txtFreeList.tag = indexPath.row
        FreeListCell.btnDelete.tag = indexPath.row
        FreeListCell.DeleteListDelegate = self
        FreeListCell.txtFreeList.text = self.arrCreateFreeList[indexPath.row]
        FreeListCell.txtFreeList.delegate = self
        FreeListCell.lblIndex.text = "\(indexPath.row + 1)."
        FreeListCell.txtFreeList.placeholder = "producto"
        
        FreeListCell.selectionStyle = .none
        return FreeListCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let FooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0))
        
        let BtnAddinToList = UIButton(frame: CGRect(x: 10, y: 5, width: 150, height: 40.0))
        BtnAddinToList.setTitle("Agregar producto", for: .normal)
        BtnAddinToList.titleLabel?.baselineAdjustment = .alignCenters
//        BtnAddinToList.titleLabel?.textAlignment = .left
        BtnAddinToList.backgroundColor = UIColor.clear
        BtnAddinToList.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 15.0)
        BtnAddinToList.setTitleColor(UIColor.black , for: .normal)
        BtnAddinToList.addTarget(self, action: #selector(self.BtnAddInToListAction), for: .touchUpInside)
        
        FooterView.addSubview(BtnAddinToList)
        
        return FooterView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

