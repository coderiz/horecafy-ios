import UIKit

class WholesalerOfferViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var category: Category?
    var family: Family?
    var demand: DemandsByWholeSaler?
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var format: UITextField!
    @IBOutlet weak var targetPrice: UITextField!
    @IBOutlet weak var comments: UITextField!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var demandNumber: UILabel!
    @IBOutlet weak var demandBrand: UILabel!
    @IBOutlet weak var demandFormat: UILabel!
    @IBOutlet weak var demandQuantyOfMonth: UILabel!
    @IBOutlet weak var demandTargetPrice: UILabel!
    @IBOutlet weak var demandComments: UILabel!
    var offerDone: Bool = false
    var demanId: Int64 {
        guard let demand = demand , let id = Int64(demand.hiddenId) else {
            return 0
        }
        return id
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryName.text = self.category?.name
        brand.delegate = self
        format.delegate = self
        targetPrice.delegate = self
        comments.delegate = self
        setupUI()
        loadDataFromApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if offerDone {
            offerDone = false
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        }
    }
    // MARK: UI
    func setupUI() {
        title = "Enviar Oferta"
        if let demand = demand {
            self.demandBrand.text = demand.brand
            self.demandNumber.text = demand.hiddenId
            self.demandFormat.text = demand.format
            if let QuantityPerMonth:Int = demand.quantyPerMonth {
                self.demandQuantyOfMonth.text = "\(QuantityPerMonth)"
            }
            
            if let TargetPrice:Double = demand.targetPrice {
                self.demandTargetPrice.text = "\(TargetPrice)"
            }
            
//            self.demandQuantyOfMonth.text = String(demand.quantyPerMonth)
//            self.demandTargetPrice.text = String(demand.targetPrice)
            self.demandComments.text = demand.comments
        }
    }
    
    // MARK: API
    func loadDataFromApi() {
        if let category = self.category {
            ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
                guard let data: Data = data as? Data else {
                    print("NO category image were loaded from api")
                    return
                }
                self.categoryImage.image = UIImage.init(data: data)
            }
        }
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        guard let offer = offerRequest() else { return }
        offerDone = true
        ApiService.instance.createOffer(offer: offer) { (response) in
            guard let _ = response as? OfferResponse else {
                showAlert(self, ERROR, OFFER_CREATE_DEMAND_FAILED)
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WholesalerThanksViewControllerID") as! ThanksOfferViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    // MARK: UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    //MARK: Private
    private func offerRequest() -> Offer? {
        guard let brand = brand.text, self.brand.text != "" else {
            showAlert(self, WARNING, BRAND_MISSING)
            return nil
        }
        
//        guard let format = format.text, self.format.text != "" else {
//            showAlert(self, WARNING, FORMAT_MISSING)
//            return nil
//        }
        
        guard let targetPrice = targetPrice.text, self.targetPrice.text != "" else {
            showAlert(self, WARNING, TARGET_PRICE_MISSING)
            return nil
        }
        
        guard let demand = demand else {
            return nil
        }
        let comments = self.comments.text ?? ""
        
        let format = self.format.text ?? ""
        
        return Offer(hiddenId: "",
                          id: "",
                          customerId: demand.customerId,
                          demandId: demanId,
                          wholesalerId: String(userId),
                          quantyPerMonth: demand.quantyPerMonth!,
                          typeOfFormatId: demand.typeOfFormatId,
                          offerPrice: Double(targetPrice.replacingOccurrences(of: ",", with: "."))!,
                          brand: brand,
                          fomat: format,
                          comments: comments,
                          createdOn: Date(),
                          borrado: false,
                          approvedByCustomer: "",
                          sentToCustomer: Date(),
                          rejected: false)
    }
    
    override func keyboardWillAppear() {
        heightConstraint.constant = 1000
        bottomConstraint.constant = 400
        reloadView()
    }
    
    override func keyboardWillDisappear() {
        heightConstraint.constant = 492
        bottomConstraint.constant = 20
        reloadView()
    }
}
