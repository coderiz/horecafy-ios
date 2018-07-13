import UIKit

class CustomerAddressDataViewController: BaseViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var provinceTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressTF.delegate = self
        cityTF.delegate = self
        provinceTF.delegate = self
        countryTF.delegate = self
    }
    //MARK: Actions
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
        
        guard let country = countryTF.text, countryTF.text != "" else {
            showAlert(self, WARNING, COUNTRY_MISSING)
            return
        }
        
        userAddressData = AddressData(address: address, city: city, zipCode: zipCode, province: province, country: country)
        dismiss(animated: true, completion: nil)
    }
    
    override func keyboardWillAppear() {
        scrollViewHeightConstraint.constant = 850
        bottomConstraint.constant = 350
        reloadView()
    }
    
    override func keyboardWillDisappear() {
        scrollViewHeightConstraint.constant = 736
        bottomConstraint.constant = 211
        reloadView()
    }
}

extension CustomerAddressDataViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true 
    }
}
