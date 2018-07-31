import UIKit

class CustomerAddListViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var category: Category?
    var family: Family?
    var demandByCustomer: DemandsByCustomer?
    var typeOfFormatSelected: TypeOfFormat?
    private var typeOfFormats = [TypeOfFormat]()
    private var typeOfFormatPI = UIPickerView()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var typeOfFormat: UITextField!
    @IBOutlet weak var quantyOfMonth: UITextField!
    @IBOutlet weak var targetPrice: UITextField!
    @IBOutlet weak var format: UITextField!
    @IBOutlet weak var comments: UITextField!
    @IBOutlet weak var categoryName: UILabel!
    
    @IBAction func acceptTapped(_ sender: Any) {
        if let demand = demand() {
            activityIndicator.startAnimating()
            ApiService.instance.createDemand(demand: demand, customerId: userId) { (response) in
                self.activityIndicator.stopAnimating()
                guard let _ = response as? DemandResponse else {
                    showAlert(self, ERROR, CUSTOMER_CREATE_DEMAND_FAILED)
                    return
                }
                if let demandVC = self.navigationController?.viewControllers[2] as? CustomerShowDemandsViewController {
                    self.navigationController?.popToViewController(demandVC, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        categoryName.text = self.category?.name
        brand.delegate = self
        quantyOfMonth.delegate = self
        targetPrice.delegate = self
        format.delegate = self
        comments.delegate = self
        typeOfFormatPI.dataSource = self
        typeOfFormatPI.delegate = self
        typeOfFormat.inputView = typeOfFormatPI
        typeOfFormat.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadDataFromApi {
        }
    }
    // MARK: UI
    private func setupUI() {
        title = "Nueva lista"
    }
    // MARK: API
    private func loadDataFromApi(completionHandler: ()->()) {
        ApiService.instance.getTypesOfFormat { (result) in
            guard let result = result as? [TypeOfFormat] else {
                print("NO type of formats were loaded from api")
                return
            }
            self.typeOfFormats = result
            self.typeOfFormats.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.typeOfFormatSelected = self.typeOfFormats[0]
            self.typeOfFormat.text = self.typeOfFormatSelected?.name
            if let demandByCustomer = self.demandByCustomer {
                self.setup(demandByCustomer: demandByCustomer)
            }
            self.typeOfFormatPI.reloadAllComponents()
        }
        
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
    
    private func setup(demandByCustomer: DemandsByCustomer) {
            self.brand.text = demandByCustomer.brand
            self.typeOfFormat.text = demandByCustomer.TypeOfFormat.name
        if let QuantityPerMonth:Int = demandByCustomer.quantyPerMonth {
            self.quantyOfMonth.text = "\(QuantityPerMonth)"
        }
        
        if let TargetPrice:Double = demandByCustomer.targetPrice {
            self.targetPrice.text = "\(TargetPrice)"
        }
            self.format.text = demandByCustomer.format
            self.comments.text = ""
    }
    
    // MARK: UIPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfFormats.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfFormats[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeOfFormatSelected = typeOfFormats[row]
        typeOfFormat.text = self.typeOfFormatSelected?.name
//        typeOfFormat.resignFirstResponder()
    }
    
    
    override func keyboardWillAppear() {
        bottomConstraint.constant = 350
        reloadView()
    }
    
    override func keyboardWillDisappear() {
        bottomConstraint.constant = 65
        reloadView()
    }
    
    private func demand() -> Demand? {
        
        guard let family = family , let typeOfFormatSelected = typeOfFormatSelected else {
            return nil
        }
        
        let brand = self.brand.text ?? ""
        let quantyOfMonth =  self.quantyOfMonth.text != "" ? Int(self.quantyOfMonth.text!) : 0
        let targetPrice = self.targetPrice.text != "" ? Double(self.targetPrice.text!.replacingOccurrences(of: ",", with: ".")) : 0.0
        let format = self.format.text ?? ""
        let comments = self.comments.text ?? ""
        let demand = Demand(hiddenId: "", familyId: family.id, quantyPerMonth: quantyOfMonth!, typeOfFormatId: typeOfFormatSelected.id, targetPrice: targetPrice!, brand: brand, format: format, comments: comments, createdOn: Date(), borrado: true)
        return demand
    }
}

//MARK:- UITextfieldDelegate Methods

extension CustomerAddListViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == typeOfFormat {
            if self.typeOfFormats.count > 0 && self.typeOfFormat.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                self.typeOfFormatSelected = typeOfFormats[0]
                typeOfFormat.text = self.typeOfFormatSelected?.name
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    
}
