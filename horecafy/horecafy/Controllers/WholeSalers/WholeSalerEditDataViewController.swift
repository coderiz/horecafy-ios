
import UIKit

class WholeSalerEditDataViewController: BaseViewController, UITextFieldDelegate, CustomerAlertView {
    private var typeOfBusiness = [TypeOfBusiness]()
    private var typeOfBusinessSelected: TypeOfBusiness?
    private var typeOfBusinessPI = UIPickerView()
    private lazy var request = CustomerRequest(user: user)
    @IBOutlet weak var nifOrCifTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var businessNameTextField: UITextField!
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGUI()
    }
    //MARK: Actions
    @IBAction func didTapInAcceptButton(_ sender: Any) {
        activityIndicator.startAnimating()
        ApiService().updateUser(request: request, customer: false) { result in
            self.activityIndicator.stopAnimating()
            showAlert(self, SUCCESS, UPDATE_CUSTOMER_OK, delegate: self)
        }
    }
    //MARK: Private Methods
    private func setupGUI() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        setupTextFields()
    }
    private func setupTextFields() {
        bottomConstraint.constant = 113
        title = "Edita tus datos"
        nifOrCifTextField.delegate = self
        emailTextField.delegate = self
        businessNameTextField.delegate = self
        contactNameTextField.delegate = self
        telephoneTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        zipCodeTextField.delegate = self
        provinceTextField.delegate = self
        countryTextField.delegate = self
        
        nifOrCifTextField.text = user.VAT
        emailTextField.text = user.email
        businessNameTextField.text = user.name
        contactNameTextField.text = user.contactName
        telephoneTextField.text = user.contactMobile
        addressTextField.text = user.address
        cityTextField.text = user.city
        zipCodeTextField.text = user.zipCode
        provinceTextField.text = user.province
        countryTextField.text = user.country
    }
    
    //MARK: CustomerAlertView
    func didTapInOkButtton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let finalString = text.replacingCharacters(in: Range(range, in: text)!, with: string)
        if finalString.isEmpty {
            return true
        }
        switch textField.tag {
        case 0:
            request.VAT = finalString
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
        case 10:
            request.country = finalString
        default:
            break
        }
        return true
    }
    
    override func keyboardWillAppear() {
        scrollViewHeightConstraint.constant = 1000
        bottomConstraint.constant = 350
        reloadView()
    }
    
    override func keyboardWillDisappear() {
        scrollViewHeightConstraint.constant = 716
        bottomConstraint.constant = 113
        reloadView()
    }
}

