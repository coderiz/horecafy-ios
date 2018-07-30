//
//  FinalStepMakeOrder.swift
//  horecafy
//
//  Created by iOS User 1 on 02/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class FinalStepMakeOrder: BaseViewController {

    
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtComments: UITextView!
    @IBOutlet var DeliverDatePicker: UIDatePicker!
    
    @IBOutlet var DeliveryTimePicker: UIDatePicker!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var arrOrders: [Dictionary<String,AnyObject>] = []
    
    var selectedWholeSalerID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //DatePicker Selection Method
    
    @IBAction func selectDateAction(_ sender: UIDatePicker) {
        self.txtDate.text = sender.date.getDeliveryDate()
    }
    
    
    @IBAction func selectTimeAction(_ sender: UIDatePicker) {
        self.txtTime.text = sender.date.getDeliveryTime()
    }
    
    
    //IBAction Methods
    
    @IBAction func btnDeliveryDate(_ sender: Any) {
        self.txtDate.becomeFirstResponder()
    }
    
    @IBAction func btnDeliveryTime(_ sender: Any) {
        self.txtTime.becomeFirstResponder()
    }
    
    
    @IBAction func btnSendOrder(_ sender: Any) {
        self.view.endEditing(true)
        if let MakeOrderRequest = MakeOrderRequest() {
            
            self.loading.startAnimating()
            ApiService.instance.createOrder(OrderRequest: MakeOrderRequest, completion: { (response) in
                self.loading.stopAnimating()
                
                guard let ResponseforOrderRequest:MakeOrderResponse = response as? MakeOrderResponse else {
                    showAlert(self, ERROR, FAILURE_TO_CREATE_ORDER)
                    return
                }
                
                if ResponseforOrderRequest.totalRows != 0 {
                    showAlert(self, SUCCESS, SUCCESS_TO_CREATE_ORDER, delegate: self)
                }
                else {
                   showAlert(self, ERROR, ResponseforOrderRequest.message)
                }
                
            })
//            ApiService.instance.createCustomerBusinessRequest(BusinessRequest: customerRequest, completion: { (response) in
//                self.loading.stopAnimating()
//                guard let ResponseForBusinessRequest:BusinessRequestResponse = response as? BusinessRequestResponse else {
//                    //                    showAlert(self, ERROR, CUSTOMER_CREATE_DEMAND_FAILED)
//                    return
//                }
//
//                if ResponseForBusinessRequest.totalRows != 0 {
//                    self.performSegue(withIdentifier: THANKS_BUSINESS_REQUEST_SEGUE, sender: nil)
//                }
//            })
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

extension FinalStepMakeOrder {
    
    func setLayout() {

        self.title = "hacer un pedido"
        self.loading.hidesWhenStopped = true
        self.txtComments.layer.cornerRadius  = 5.0
        self.txtComments.layer.borderColor = UIColor.lightGray.cgColor
        self.txtComments.layer.borderWidth = 1.0
        self.txtComments.layer.masksToBounds = true
        self.txtDate.tag = 55555
        self.txtTime.tag = 55555
        self.DeliverDatePicker.translatesAutoresizingMaskIntoConstraints = false
        self.DeliveryTimePicker.translatesAutoresizingMaskIntoConstraints = false
        self.txtDate.inputView = self.DeliverDatePicker
        self.txtTime.inputView = self.DeliveryTimePicker
        self.txtDate.text = Date().getDeliveryDate()
        self.txtTime.text = Date().getDeliveryTime()
        
        self.txtDate.setDropDownButton()
        self.txtTime.setDropDownButton()
        
    }
    
    private func MakeOrderRequest() -> MakeAnOrder? {
        
        
        guard let DeliveryDate = self.txtDate.text, self.txtDate.text != "" else {
            showAlert(self, WARNING, MISSING_DELIVERY_DATE)
            return nil
        }
        
//        let Products:String = ""
        var arrOrderlist:[String] = []
        
        for Product in self.arrOrders {
            let ProductName = Product["ProductName"] as! String
            let Qty = Product["Qty"] as! String
            let productDetail = "\(ProductName):\(Qty)"
            arrOrderlist.append(productDetail)
        }
        
        let ProductDesc = arrOrderlist.joined(separator: "#")
        
        let MakeOrderRequest = MakeAnOrder(customerId: Int(userId), WholesalerId: Int(selectedWholeSalerID)!, deliveryDate: DeliveryDate, products: ProductDesc, deliveryTime: (self.txtTime.text != "" ? self.txtTime.text : ""), comments: (self.txtComments.text != "" ? self.txtComments.text : ""))
        
//        let Request = CustomerBusinessRequest(customerId: Int(userId), productName: productName, brand: brand, consumption: MonthConsumption, targetPrice: targetPrice, MailFlag: sucessValue)
        
        return MakeOrderRequest
    }
    
    
}


extension FinalStepMakeOrder : CustomerAlertView {
    
    func didTapInOkButtton(isSuccess: Bool) {
        if isSuccess == true {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
