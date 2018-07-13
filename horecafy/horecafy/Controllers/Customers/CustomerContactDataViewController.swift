import UIKit

class CustomerContactDataViewController: BaseViewController {
    
    @IBOutlet weak var contactNameTF: UITextField!
    @IBOutlet weak var contactPhoneTF: UITextField!

    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func accept(_ sender: Any) {
        guard let contactName = contactNameTF.text, contactNameTF.text != "" else {
            showAlert(self, WARNING, NAME_MISSING)
            return
        }
                
        guard let contactPhone = contactPhoneTF.text, contactPhoneTF.text != "" else {
            showAlert(self, WARNING, PHONE_MISSING)
            return
        }
        
        userContactData = ContactData(contactName: contactName, contactMobile: contactPhone)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func keyboardWillAppear() {
        bottomHeightConstraint.constant = 350
        reloadView()
    }
    
    override func keyboardWillDisappear() {
        bottomHeightConstraint.constant = 16
        reloadView()
    }
}
