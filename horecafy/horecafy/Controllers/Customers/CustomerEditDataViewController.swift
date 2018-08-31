
import UIKit

class CustomerEditDataViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CustomerAlertView {
    private var typeOfBusiness = [TypeOfBusiness]()
    private var typeOfBusinessSelected: TypeOfBusiness?
    private var typeOfBusinessPI = UIPickerView()
    private lazy var request = CustomerRequest(user: user)
    @IBOutlet weak var nifOrCifTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var typeOfBusinessTextField: UITextField!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var stateList = [ProvinceData]()
    private var stateListSelected: ProvinceData?
    private var provincePickerView = UIPickerView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGUI()
    }
    //MARK: Actions
    @IBAction func didTapInAcceptButton(_ sender: Any) {
        activityIndicator.startAnimating()
        ApiService().updateUser(request: request, customer: true) { result in
            self.activityIndicator.stopAnimating()
            showAlert(self, SUCCESS, UPDATE_CUSTOMER_OK, delegate: self)
        }
    }
    //MARK: UIPickerDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.provincePickerView
        {
            return stateList.count
        }
        else
        {
            return typeOfBusiness.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.provincePickerView
        {
            return stateList[row].province
        }
        else
        {
            return typeOfBusiness[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.provincePickerView
        {
            self.stateListSelected = stateList[row]
            provinceTextField.text = self.stateListSelected?.province
            request.province = stateListSelected?.province
        }
        else
        {
            self.typeOfBusinessSelected = typeOfBusiness[row]
            typeOfBusinessTextField.text = self.typeOfBusinessSelected?.name
            request.typeOfBusinessId = typeOfBusinessSelected?.id
        }

    }
    
    //MARK: Private Methods
    private func setupGUI() {
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        setupPicker(id: user.typeOfBusinessId)
        setupTextFields()
    }
    private func setupTextFields() {
        bottomConstraint.constant = 113
        title = "Edita tus datos"
//        nifOrCifTextField.delegate = self
        emailTextField.delegate = self
        businessNameTextField.delegate = self
        typeOfBusinessTextField.delegate = self
        contactNameTextField.delegate = self
        telephoneTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        zipCodeTextField.delegate = self
        provinceTextField.delegate = self
//        countryTextField.delegate = self
    
//        nifOrCifTextField.text = user.VAT
        emailTextField.text = user.email
        businessNameTextField.text = user.name
        contactNameTextField.text = user.contactName
        telephoneTextField.text = user.contactMobile
        addressTextField.text = user.address
        cityTextField.text = user.city
        zipCodeTextField.text = user.zipCode
        provinceTextField.text = user.province
//        countryTextField.text = user.country
    }
    //MARK: CustomerAlertView
    func didTapInOkButtton(isSuccess: Bool) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    // MARK: API
    private func setupPicker(id: Int) {
        typeOfBusinessPI.dataSource = self
        typeOfBusinessPI.delegate = self
        typeOfBusinessTextField.inputView = typeOfBusinessPI
        typeOfBusinessTextField.delegate = self
        activityIndicator.startAnimating()
        ApiService.instance.getTypeOfBusiness { (result) in
            self.activityIndicator.stopAnimating()
            guard let result: [TypeOfBusiness] = result as? [TypeOfBusiness] else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            self.typeOfBusiness = result
            self.typeOfBusiness.remove(at: 0) // delete the firstone because is just for dropdownlists
            let businnesFilter = self.typeOfBusiness.filter{
                $0.id == id
            }
            if let businnes = businnesFilter.first {
                self.typeOfBusinessTextField.text = businnes.name
            } else {
                self.typeOfBusinessTextField.text = ""
            }
            self.typeOfBusinessPI.reloadAllComponents()
        }
        
        provincePickerView.dataSource = self
        provincePickerView.delegate = self
        provinceTextField.inputView = provincePickerView
        provinceTextField.delegate = self
        activityIndicator.startAnimating()
        ApiService.instance.getProvinceList(completion: { (result) in
            self.activityIndicator.stopAnimating()
            
            guard let result: [ProvinceData] = result as? [ProvinceData] else
            {
                print("No Provinces were loaded from api")
                return
            }
            
            
            self.stateList = result
            let statefilter = self.stateList.filter{
                $0.id == String(id)
            }
            if let state = statefilter.first {
                self.provinceTextField.text = self.user.province
            } else {
                self.provinceTextField.text = ""
            }
            self.provincePickerView.reloadAllComponents()
        })
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == typeOfBusinessTextField {
            if self.typeOfBusiness.count > 0 && self.typeOfBusinessTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                self.typeOfBusinessSelected = typeOfBusiness[0]
                typeOfBusinessTextField.text = self.typeOfBusinessSelected?.name
                request.typeOfBusinessId = typeOfBusinessSelected?.id
            }
        }
        else if textField == provinceTextField
        {
            if self.stateList.count > 0 && self.provinceTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0
            {
                self.stateListSelected = stateList[0]
                provinceTextField.text = self.stateListSelected?.province
                request.province = stateListSelected?.province
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let finalString = text.replacingCharacters(in: Range(range, in: text)!, with: string)
        if finalString.isEmpty {
            return true
        }
        switch textField.tag {
//        case 0:
//            request.VAT = finalString
        case 1:
            request.email = finalString
        case 2:
            request.name = finalString
        case 3:
            request.typeOfBusinessId = typeOfBusinessSelected?.id
        case 4:
            request.contactName = finalString
        case 5:
            request.contactMobile = finalString
        case 6:
            request.address = finalString
        case 7:
            request.city = finalString
        case 8:
            request.zipCode = finalString
        case 9:
            request.province = finalString
//        case 10:
//            request.country = finalString
        default:
            break
        }
        return true
    }

}


