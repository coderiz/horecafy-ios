import UIKit

class CustomerAddressDataViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var provinceTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
  
    var stateList = [ProvinceData]()
    private var stateListSelected: ProvinceData?
    private var provincePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getProvinceList()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        addressTF.delegate = self
        cityTF.delegate = self
        provinceTF.delegate = self
    }
    
    func getProvinceList()
    {
        provincePickerView.dataSource = self
        provincePickerView.delegate = self
        provinceTF.inputView = provincePickerView
        provinceTF.delegate = self

        ApiService.instance.getProvinceList(completion: { (result) in
            
            guard let result: [ProvinceData] = result as? [ProvinceData] else
            {
                print("No Provinces were loaded from api")
                return
            }

            self.stateList = result
            
            self.provincePickerView.reloadAllComponents()
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.stateList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateList[row].province
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.stateListSelected = stateList[row]
        provinceTF.text = self.stateListSelected?.province
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
        
//        guard let country = countryTF.text, countryTF.text != "" else {
//            showAlert(self, WARNING, COUNTRY_MISSING)
//            return
//        }
        userAddressData = AddressData(address: address, city: city, zipCode: zipCode, province: province, country: "")
        dismiss(animated: true, completion: nil)
    }
    
}

extension CustomerAddressDataViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true 
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == provinceTF
        {
            if self.stateList.count > 0 && self.provinceTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0
            {
                self.stateListSelected = stateList[0]
                provinceTF.text = self.stateListSelected?.province
            }
        }
        return true
    }
}
