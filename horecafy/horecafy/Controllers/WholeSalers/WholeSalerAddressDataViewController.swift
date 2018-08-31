import UIKit

class WholeSalerAddressDataViewController: BaseViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var provinceTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var getStateList = [ProvinceData]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        provinceTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectedProvinces(notification:)), name: Notification.Name("selectedProvinces"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            self.activityIndicator.startAnimating()
            self.getProvinceList()
        }
    }
    
    func getProvinceList()
    {
        ApiService.instance.getProvinceList(completion: { (result) in
            
            self.activityIndicator.stopAnimating()
            
            guard let result: [ProvinceData] = result as? [ProvinceData] else
            {
                print("No Provinces were loaded from api")
                return
            }
            
            self.getStateList = result
        })
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func accept(_ sender: Any) {
        guard let address = addressTF.text, addressTF.text != "" else {
            showAlert(self, WARNING, ADDRESS_MISSING)
            return
        }
        
        guard let city = cityTF.text, cityTF.text != "" else {
            showAlert(self, WARNING, CITY_MISSING)
            return
        }
        
        guard let zipCode = zipCodeTF.text, zipCodeTF.text != "" else {
            showAlert(self, WARNING, ZIP_CODE_MISSING)
            return
        }
        
        guard let province = provinceTF.text, provinceTF.text != "" else {
            showAlert(self, WARNING, PROVINCE_MISSING)
            return
        }
        
//        guard let country = countryTF.text, countryTF.text != "" else {
//            showAlert(self, WARNING, COUNTRY_MISSING)
//            return
//        }
        
        userAddressData = AddressData(address: address, city: city, zipCode: zipCode, province: province, country: "")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectedProvinces(notification: Notification)
    {
        let provinceString = notification.object as? String
        provinceTF.text = provinceString!
    }

}

extension WholeSalerAddressDataViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == provinceTF
        {
            self.view.endEditing(true)
            
            let mainSB = UIStoryboard(name: "main", bundle: nil)
            let VC = mainSB.instantiateViewController(withIdentifier: "ProvinceListPopupVC") as! ProvinceListPopupVC
            VC.isFrom = "CreateAccount"
            VC.stateList = self.getStateList
            if textField.text != ""
            {
                VC.textFieldValue = textField.text!
            }
            self.present(VC, animated: true, completion: nil)
        }
    }
}
