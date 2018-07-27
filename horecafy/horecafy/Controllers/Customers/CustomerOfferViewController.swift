import UIKit

class CustomerOfferViewController: BaseViewController, UITextFieldDelegate {
    var category: Category?
    var family: Family?
    var offer: OfferCustomer?
    var demand: DemandsByCustomer?
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var format: UILabel!
    @IBOutlet weak var targetPrice: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var demandNumber: UILabel!
    @IBOutlet weak var demandBrand: UILabel!
    @IBOutlet weak var demandFormat: UILabel!
    @IBOutlet weak var demandQuantyOfMonth: UILabel!
    @IBOutlet weak var demandTargetPrice: UILabel!
    @IBOutlet weak var demandComments: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDataFromApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    // MARK: UI
    func setupUI() {
        title = "Aceptar Oferta"
        if let category = category {
            categoryTitleLabel.text = category.name
        }
        if let demand = demand {
            self.demandBrand.text = demand.brand
            self.demandNumber.text = "\(demand.hiddenId)"
            self.demandFormat.text = demand.format
            if let QuantityPerMonth:Int = demand.quantyPerMonth {
                self.demandQuantyOfMonth.text = "\(QuantityPerMonth)"
            }
            if let TargetPrice:Double = demand.targetPrice {
                self.demandTargetPrice.text = "\(TargetPrice)"
            }
        }
        
        if let offer = offer, let price = offer.offerPrice {
            self.brand.text = offer.brand ?? ""
            self.format.text = offer.format ?? ""
            self.targetPrice.text = "\(price)"
            self.comments.text = ""
        }
    }
    // MARK: API
    func loadDataFromApi() {
        if let offer = offer, let id = offer.hiddenId {
            ApiService.instance.fetchInfoOffer(offerId: id) { result in
                guard let makeOffers = result as? [MakeOffer], let makeOffer = makeOffers.first else { return }
                self.demandComments.text = makeOffer.demand?.comments
                self.comments.text = makeOffer.comments
            }
        }
        
        if let category = self.category {
            ApiService.instance.getCategoryImage(categoryImage: category.image) { (data) in
                guard let data: Data = data as? Data else {
                    print("NO category image were loaded from api")
                    return
                }
                self.categoryImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        guard let offer = offer, let id = offer.hiddenId else {
            return
        }
        activityIndicator.startAnimating()
        ApiService.instance.customerAcceptOffer(offerId: id) { (result) in
            self.activityIndicator.stopAnimating()
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: THANKS) as? ThanksOfferViewController {
                self.present(vc, animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }
    // MARK: UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func keyboardWillAppear() {
        bottomConstraint.constant += 350
        reloadView()
    }
    
    override func keyboardWillDisappear() {
        bottomConstraint.constant -= 350
        reloadView()
    }
}
