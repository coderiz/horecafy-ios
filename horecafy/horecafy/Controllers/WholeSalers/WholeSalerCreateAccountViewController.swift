
import UIKit

class WholeSalerCreateAccountViewController: BaseViewController, UITextFieldDelegate
{
    @IBOutlet weak var vatTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       // vatTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        rePasswordTF.delegate = self
        nameTF.delegate = self
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        userAddressData = nil
        userContactData = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any)
    {
        
        guard let vat = vatTF.text?.removingSpacesAndNewLines, vatTF.text != "" else {
            showAlert(self, WARNING, VAT_MISSING)
            return
        }

        guard let email = emailTF.text?.removingSpacesAndNewLines, emailTF.text != "" else {
            showAlert(self, WARNING, EMAIL_MISSING)
            return
        }
        
        guard let password = passwordTF.text?.removingSpacesAndNewLines, passwordTF.text != "" else {
            showAlert(self, WARNING, PASSWORD_MISSING)
            return
        }
        
        guard let repassword = rePasswordTF.text?.removingSpacesAndNewLines, rePasswordTF.text != "" else {
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
        
        guard let contactData = userContactData else {
            showAlert(self, WARNING, CONTACT_DATA_ERROR)
            return
        }
        
        guard let addresData = userAddressData else {
            showAlert(self, WARNING, ADDRESS_DATA_ERROR)
            return
        }
        
        let user = User(hiddenId: "", id: "", VAT: vat, email: email, name: name, typeOfBusinessId: 0, contactName: contactData.contactName, contactEmail: email, contactMobile: contactData.contactMobile, address: addresData.address, city: addresData.city, zipCode: addresData.zipCode, province: addresData.province, createdOn: Date(), visible: true)
//        let user = User(hiddenId: "", id: "", VAT: vat, email: email, name: name, typeOfBusinessId: 0, contactName: contactData.contactName, contactEmail: email, contactMobile: contactData.contactMobile, address: addresData.address, city: addresData.city, zipCode: addresData.zipCode, province: addresData.province, country: addresData.country, createdOn: Date(), visible: true)
        
        ApiService.instance.createWholeSaler(user: user, password: password) { (response) in
            guard let customerResponse = response as? WholeSalerResponse else {
                showAlert(self, ERROR, WHOLESALER_CREATE_FAILED)
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: WHOLESALER_ADDRESS_DATA) as! WholeSalerAddressDataViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addContactData(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: WHOLESALER_CONTACT_DATA) as! WholeSalerContactDataViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
