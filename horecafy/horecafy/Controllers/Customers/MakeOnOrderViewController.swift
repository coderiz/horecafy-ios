//
//  MakeOnOrderViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 30/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class MakeOnOrderViewController: BaseViewController {

    var arrMakeOnOrder:[Dictionary<String,Any>] = []
    var arrDistributors:[Distributor] = []
    
    @IBOutlet weak var tblProductList: UITableView!
    
    @IBOutlet weak var txtDistribution: UITextField!
    
    @IBOutlet var DistributorPickerView: UIPickerView!
    
    @IBOutlet weak var Loading: UIActivityIndicatorView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    var arrFinalOrderList:[Dictionary<String,Any>] = []
    
    var selectedDistributorId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetLayout()
        self.getWholeSalerList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //IB Action Methods
    
    @objc func BtnAddInToListAction() {
        var DictObject = Dictionary<String,Any>()
        DictObject["ProductName"] = ""
        DictObject["Qty"] = ""
        arrMakeOnOrder.append(DictObject)
        self.tblProductList.reloadData()
    }
    
    
    @IBAction func btnSelectDistributor(_ sender: Any) {
        self.txtDistribution.becomeFirstResponder()
        
    }
    
    
    @IBAction func btnAddFreeList(_ sender: Any) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.CreatOrderList()
        }
        
    }
    
    @IBAction func btnSendInvitation(_ sender: Any) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: SEND_DISTRIBUTOR_INVITE, sender: nil)
    }
    
    
    func CreatOrderList() {
        let arrOrderLIst = self.arrMakeOnOrder.filter({ (response) -> Bool in
            return response["ProductName"] as? String != "" || response["Qty"] as? String != ""
        }) as [Dictionary<String, AnyObject>]
        
        var arrFilteredOrder:[Dictionary<String,AnyObject>] = []
        
        if arrOrderLIst.count == 0 {
            showAlert(self, ERROR, MISSING_FREE_LIST_ERROR)
            return
        }
        else if arrOrderLIst.count > 0 {
            arrFilteredOrder = self.arrMakeOnOrder.filter({ (response) -> Bool in
                return response["ProductName"] as? String != "" && response["Qty"] as? String != ""
            }) as [Dictionary<String, AnyObject>]
            
            if arrOrderLIst.count != arrFilteredOrder.count {
                showAlert(self, ERROR, MISSING_PROPER_PRODUCT_DETAIL)
                return
            }
        }
        
        self.arrFinalOrderList = arrFilteredOrder
        self.performSegue(withIdentifier: MAKE_ORDER_FINAL_STEP_SEGUE, sender: nil)
        
//
//        let OrderSummeryPage = self.storyboard?.instantiateViewController(withIdentifier: "FinalStepMakeOrder") as! FinalStepMakeOrder
//        OrderSummeryPage.arrOrders = arrFilteredOrder
//        OrderSummeryPage.selectedWholeSalerID = self.selectedDistributorId
//        self.navigationController?.pushViewController(OrderSummeryPage, animated: true)
    
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == MAKE_ORDER_FINAL_STEP_SEGUE {
            let vc = segue.destination as! FinalStepMakeOrder
            vc.arrOrders = self.arrFinalOrderList as [Dictionary<String, AnyObject>]
            vc.selectedWholeSalerID = self.selectedDistributorId
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

extension MakeOnOrderViewController {
    
    func SetLayout() {
        self.title = "hacer un pedido"
        self.Loading.hidesWhenStopped = true
        self.tblProductList.tableFooterView = UIView()
        self.DistributorPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.txtDistribution.inputView = self.DistributorPickerView
        self.setDropDownButton()
        self.txtDistribution.tag = 55555
        self.btnSubmit.isHidden = true
        var DictObject = Dictionary<String,Any>()
        DictObject["ProductName"] = ""
        DictObject["Qty"] = ""
        arrMakeOnOrder.append(DictObject)
        self.tblProductList.reloadData()
        
    }
    
    func setDropDownButton() {
        
        let arrow = UIImageView(image: UIImage(named: "DropDown"))
        arrow.backgroundColor = UIColor.clear
        arrow.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        arrow.contentMode = UIViewContentMode.center
        
        let RightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 40, height: 40))
        RightView.backgroundColor = UIColor.clear
        RightView.addSubview(arrow)
        self.txtDistribution.rightView = RightView
        self.txtDistribution.rightViewMode = UITextFieldViewMode.always
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func getWholeSalerList(){
        self.Loading.startAnimating()
        ApiService.instance.getWholeSalerList { (result) in
            self.Loading.stopAnimating()
            guard let result: [Distributor] = result as? [Distributor] else {
                print("NO lists were loaded from api")
                return
            }
            self.arrDistributors = result
            self.DistributorPickerView.reloadAllComponents()
        }
    }
    
    
}

//MARK:- UITextfield Delegate Methods

extension MakeOnOrderViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var returnvalue:Bool = true
        
        if (textField != self.txtDistribution && textField.tag >= 10000) {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if string != numberFiltered {
                returnvalue = false
            }
        }
       return returnvalue
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtDistribution {
            if self.selectedDistributorId != "" {
                self.btnSubmit.isHidden = false
            }
            else {
                self.btnSubmit.isHidden = true
            }
        }
        else {
            let TextFieldIndex = textField.tag
            let textSTring = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if textSTring != "" {
                if TextFieldIndex >= 10000 {
                    let QtyIndex = Int(TextFieldIndex - 10000)
                    var DictObject = self.arrMakeOnOrder[QtyIndex]
                    DictObject["Qty"] = textSTring
                    self.arrMakeOnOrder[QtyIndex] = DictObject
                }
                else {
                    var DictObject = self.arrMakeOnOrder[TextFieldIndex]
                    DictObject["ProductName"] = textSTring
                    self.arrMakeOnOrder[TextFieldIndex] = DictObject
                }
            }
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

//MARK:- Delete Product Delegate Methods

extension MakeOnOrderViewController : btnDeleteOrderDelegate {
    
    func BtnDeleteMethod(btnIndex: Int) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.deleteRow(Index: btnIndex)
        }
        
    }
    
    func deleteRow(Index:Int) {
        if self.arrMakeOnOrder.count > 1 {
        self.arrMakeOnOrder.remove(at: Index)
        self.tblProductList.reloadData()
        }
    }
    
}

//MARK:- UIPickerview Datasource & Delegate Methods

extension MakeOnOrderViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if self.arrDistributors.count > 0 {
//            return self.arrDistributors.count + 1
//        }
        return self.arrDistributors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var RowTitle = ""
        
//        if row == self.arrDistributors.count {
//            RowTitle = "Invitar a distribuidor nuevo"
//        }
//        else {
            RowTitle = self.arrDistributors[row].name
//        }
        return RowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if row == self.arrDistributors.count {
       
            
//            print("Invite FriendList")
//            RowTitle = "Invitar a distribuidor nuevo"
//        }
//        else {
        if self.arrDistributors.count > 0 {
            self.txtDistribution.text = self.arrDistributors[row].name
            self.selectedDistributorId = self.arrDistributors[row].hiddenId
        }
//        }
    }
}


//MARK:- UITableView Datasource & Delegate Methods

extension MakeOnOrderViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMakeOnOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let MakeOrderCell:MakeOrder  = self.tblProductList.dequeueReusableCell(withIdentifier: "MakeOrder") as! MakeOrder
        MakeOrderCell.txtProductName.tag = indexPath.row
        //Quantity Tag index multiplied by 10000 only because of will not conflict to get Proper index
        let QtyIndex = indexPath.row + 10000
        MakeOrderCell.txtQuantity.tag = QtyIndex
        MakeOrderCell.btnDelete.tag = indexPath.row
        MakeOrderCell.DeleteOrderDelegate = self
        let DictObject = self.arrMakeOnOrder[indexPath.row] as Dictionary<String,AnyObject>
        
        MakeOrderCell.txtQuantity.text = DictObject["Qty"] as? String
        MakeOrderCell.txtProductName.text = DictObject["ProductName"] as? String
        MakeOrderCell.txtQuantity.delegate = self
        MakeOrderCell.txtProductName.delegate = self
        MakeOrderCell.lblIndex.text = "\(indexPath.row + 1)."
        MakeOrderCell.txtProductName.placeholder = "producto"
        MakeOrderCell.txtQuantity.placeholder = "cantidad"
        
        MakeOrderCell.txtQuantity.keyboardType = .default
        MakeOrderCell.txtProductName.keyboardType = .default
        MakeOrderCell.selectionStyle = .none
        return MakeOrderCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let FooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0))
        let BtnAddinToList = UIButton(frame: CGRect(x: 16, y: 5, width: UIScreen.main.bounds.width - 32, height: 40.0))
        BtnAddinToList.setTitle("Agregar producto", for: .normal)
        BtnAddinToList.titleLabel?.baselineAdjustment = .alignCenters
        BtnAddinToList.backgroundColor = UIColor.clear
        BtnAddinToList.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//            UIFont(name: "HelveticaNeue-Regular", size: 15.0)
        BtnAddinToList.setTitleColor(UIColor(red: 59.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0) , for: .normal)
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
