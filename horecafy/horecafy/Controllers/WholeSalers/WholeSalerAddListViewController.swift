import UIKit

class WholeSalerAddListViewController: BaseViewController, UIPickerViewDelegate, UITextFieldDelegate {
    var category: Category?
    var initialValue: CGFloat!
    var family: Family?
    private var wholeSalerId: Int64 {
        let credentials = loadCredentials()
        return credentials.userId
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var acceptButtonVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var comments: UITextField!
    @IBOutlet weak var categoryName: UILabel!
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialValue = acceptButtonVerticalConstraint.constant
        activityIndicator.hidesWhenStopped = true 
        activityIndicator.stopAnimating()
        categoryName.text = self.category?.name
        brand.delegate = self
        comments.delegate = self
        setupUI()
        loadDataFromApi()
    }
    
    override func keyboardWillAppear() {
        acceptButtonVerticalConstraint.constant = 250
        self.checkConstraintStatus()
    }
    
    override func keyboardWillDisappear() {
        acceptButtonVerticalConstraint.constant = 20
        self.checkConstraintStatus()
    }
    //MARK: Actions
    @IBAction func acceptTapped(_ sender: Any) {
      view.endEditing(true)
        if let list = wholeSharedList() {
            activityIndicator.startAnimating()
            ApiService.instance.createList(list: list, wholeSalerId: wholeSalerId) { (response) in
                self.activityIndicator.stopAnimating()
                guard let _ = response as? WholeSalerListResponse else {
                    showAlert(self, ERROR, CUSTOMER_CREATE_DEMAND_FAILED)
                    return
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            showAlert(self, WARNING, BRAND_MISSING)
        }
    }
    // MARK: UI
    func setupUI() {
        title = "Nueva lista"
    }
    // MARK: API
    func loadDataFromApi() {
        if let category = self.category {
            ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
                guard let data: Data = data as? Data else {
                    print("NO category image were loaded from api")
                    return
                }
                self.categoryImage.image = UIImage(data: data)
            }
        }
    }
    // MARK: UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    private func checkConstraintStatus() {
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    //MARK: Private Methods
    private func wholeSharedList() -> WholeSalerList? {
        guard let family = family, let brand = brand.text, self.brand.text != "" else {
            showAlert(self, ERROR, BRAND_MISSING)
             return nil
        }
        let comments = self.comments.text
        let credentials = loadCredentials()
        let wholeSalerId = credentials.userId
        return WholeSalerList(wholeSalerId: String(wholeSalerId), familyId: family.id, brand: brand, comments: comments ?? "", borrado: false)
    }
}
