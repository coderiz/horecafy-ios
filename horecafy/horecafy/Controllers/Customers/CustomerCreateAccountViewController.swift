import UIKit

class CustomerCreateAccountViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var typeOfBusiness = [TypeOfBusiness]()
    var typeOfBusinessSelected: TypeOfBusiness?
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var vatTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var typeOfBusinessTF: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var typeOfBusinessPI = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vatTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        rePasswordTF.delegate = self
        nameTF.delegate = self
        typeOfBusinessPI.dataSource = self
        typeOfBusinessPI.delegate = self
        typeOfBusinessTF.inputView = typeOfBusinessPI
        typeOfBusinessTF.delegate = self
        loadDataFromApi()
    }
    
    @IBAction func goBack(_ sender: Any) {
        userAddressData = nil
        userContactData = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        guard let vat = vatTF.text, vatTF.text != "" else {
            showAlert(self, WARNING, VAT_MISSING)
            return
        }
        
        guard let email = emailTF.text, emailTF.text != "" else {
            showAlert(self, WARNING, EMAIL_MISSING)
            return
        }
        
        guard let password = passwordTF.text, passwordTF.text != "" else {
            showAlert(self, WARNING, PASSWORD_MISSING)
            return
        }
        
        guard let repassword = rePasswordTF.text, rePasswordTF.text != "" else {
            showAlert(self, WARNING, RE_PASSWORD_MISSING)
            return
        }
        
        guard password == repassword else {
            showAlert(self, WARNING, PASSWORDS_ARE_NOT_EQUAL)
            return
        }
        
        guard let name = nameTF.text, nameTF.text != "" else {
            showAlert(self, WARNING, NAME_MISSING)
            return
        }
        
        guard let typeOfBusiness = typeOfBusinessSelected else {
            showAlert(self, WARNING, TYPE_OF_BUSINESS_MISSING)
            return
        }
        
        guard let contactData = userContactData else {
            showAlert(self, WARNING, CONTACT_DATA_ERROR)
            return
        }
        
        guard let addresData = userAddressData else {
            showAlert(self, WARNING, ADDRESS_DATA_ERROR)
            return;
        }
        

        
        let user = User(hiddenId: "", id: "", VAT: vat, email: email, name: name, typeOfBusinessId: typeOfBusiness.id, contactName: contactData.contactName, contactEmail: email, contactMobile: contactData.contactMobile, address: addresData.address, city: addresData.city, zipCode: addresData.zipCode, province: addresData.province, country: addresData.country, createdOn: Date(), visible: true)
        self.loading.startAnimating()
        ApiService.instance.createCustomer(user: user, password: password) { (response) in
            
            self.loading.stopAnimating()
            guard let customerResponse = response as? CustomerResponse else {
                showAlert(self, ERROR, CUSTOMER_CREATE_FAILED)
                return
            }
            
            if customerResponse.error == "VAT_DUPLICATED" {
                showAlert(self, ERROR, VAT_DUPLICATED)
                return
            }
            if customerResponse.error == "EMAIL_DUPLICATED" {
                showAlert(self, ERROR, EMAIL_DUPLICATED)
                return
            }
        
            userAddressData = nil
            userContactData = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addAddress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CUSTOMER_ADDRESS_DATA) as! CustomerAddressDataViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addContactData(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CUSTOMER_CONTACT_DATA) as! CustomerContactDataViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: API
    func loadDataFromApi() {
        ApiService.instance.getTypeOfBusiness { (result) in
            guard let result: [TypeOfBusiness] = result as? [TypeOfBusiness] else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            self.typeOfBusiness = result
            self.typeOfBusiness.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.typeOfBusinessPI.reloadAllComponents()
        }
    }
    
    // MARK: UIPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfBusiness.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfBusiness[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeOfBusinessSelected = typeOfBusiness[row]
        typeOfBusinessTF.text = self.typeOfBusinessSelected?.name
//        typeOfBusinessTF.resignFirstResponder()
    }
    

    override func keyboardWillAppear() {
        scrollViewHeightConstraint.constant = 800
        bottomConstraint.constant = 350
        reloadView()
    }
    
    override func keyboardWillDisappear() {
        scrollViewHeightConstraint.constant = 716
        bottomConstraint.constant = 199
        reloadView()
    }
}

//MARK:- UITextfieldDelegate Methods

extension CustomerCreateAccountViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == typeOfBusinessTF {
            if self.typeOfBusiness.count > 0 && self.typeOfBusinessTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0{
                self.typeOfBusinessSelected = typeOfBusiness[0]
                typeOfBusinessTF.text = self.typeOfBusinessSelected?.name
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}
