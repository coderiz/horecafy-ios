import UIKit
import MobileCoreServices
import AssetsLibrary
import MediaPlayer
import AVFoundation

class WholesalerOfferViewController: BaseViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    @IBOutlet weak var uploadImageCollectionView: UICollectionView!
    @IBOutlet weak var ivThumbnailVideo: UIImageView!

    var ImageDictionary : [String : UIImage] = [:]
    var currentPickIndex: Int = -1
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    
    var videoUrl: URL!
    
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
        
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WholesalerOfferUploadImageCell", for: indexPath) as! WholesalerOfferUploadImageCell
        
        if let image = self.ImageDictionary["\(indexPath.item)"] as? UIImage
        {
            cell.uploadImage.image = image
        }
        else
        {
            cell.uploadImage.image = UIImage(named: "Add")
        }
        
        cell.btnAdd.tag = indexPath.item
        cell.btnAdd.addTarget(self, action: #selector(self.addImageAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let widthPerItem = 50.0
        
        let heightPerItem = widthPerItem
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    @IBAction func addImageAction(sender: UIButton) {
        let alert = UIAlertController(title: "Seleccione la acción", message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Capturar fotos desde la cámara", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.openCamera()
            }
            else
            {
                let errAlert = UIAlertController(title: "No hay cámara disponible en tu dispositivo", message: nil, preferredStyle: .alert)
                errAlert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                self.present(errAlert, animated: true, completion: nil)
            }
        }
        alert.addAction(cameraAction)
        let albumAction = UIAlertAction(title: "Seleccionar foto de la galería", style: .default) { action in
            self.openPhotoAlbum()
        }
        alert.addAction(albumAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { action in }
        alert.addAction(cancelAction)
        
        self.currentPickIndex = sender.tag
        
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        controller.allowsEditing = false
        present(controller, animated: true, completion: {
        })
    }
    
    func openPhotoAlbum()
    {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        controller.allowsEditing = false
        present(controller, animated: true, completion: {
        })
    }
    
    @IBAction func addVideoAction(sender: UIButton) {
        let alert = UIAlertController(title: "Seleccione la acción", message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Capture video de la cámara", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.captureVideo()
            }
            else
            {
                let errAlert = UIAlertController(title: "No hay cámara disponible en tu dispositivo", message: nil, preferredStyle: .alert)
                errAlert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                self.present(errAlert, animated: true, completion: nil)
            }
        }
        alert.addAction(cameraAction)
        let albumAction = UIAlertAction(title: "Seleccionar video de la galería", style: .default) { action in
            self.selectVideo()
        }
        alert.addAction(albumAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { action in }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func captureVideo()
    {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        controller.mediaTypes = ["public.movie"]
        controller.allowsEditing = false
        controller.videoMaximumDuration = 90.0
        present(controller, animated: true)
    }
    
    func selectVideo()
    {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        controller.mediaTypes = ["public.movie"]
        controller.videoMaximumDuration = 90.0
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if picker.mediaTypes == ["public.movie"]
        {
            var VideoURL:String = ""
            
            guard let capturedVideoURL = info[UIImagePickerControllerMediaURL] as? URL else {
                dismiss(animated: true, completion: nil)
                return
            }
            
            if let selectedVideoURL = info[UIImagePickerControllerMediaURL] as? URL {
                VideoURL = "\(selectedVideoURL)"
                self.videoUrl = selectedVideoURL
            }
            
            var thumbnail: UIImage!
            
            thumbnail = self.thumbnailImageFromURL(videoURLString: VideoURL) as? UIImage
            self.ivThumbnailVideo.image = thumbnail
            
            dismiss(animated: true, completion: nil)
        }
        else
        {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                dismiss(animated: true, completion:nil)
                return
            }
            
            self.ImageDictionary["\(currentPickIndex)"] = image
            
            dismiss(animated: true, completion:nil)
            
            self.uploadImageCollectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion:nil)
    }
    
    func thumbnailImageFromURL(videoURLString : String) -> UIImage {
        let videoURL = URL(string: videoURLString)
        let asset = AVURLAsset(url: videoURL! , options: nil)
        let generator = AVAssetImageGenerator.init(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let requestedTime : CMTime = CMTimeMake(1, 10)
        var imgRef:UIImage = UIImage()
        do {
            imgRef = UIImage(cgImage: try generator.copyCGImage(at: requestedTime, actualTime: nil))
        } catch {
            
        }
        return imgRef
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        guard let offer = offerRequest() else { return }
        offerDone = true
        activityIndicator.startAnimating()
        ApiService.instance.createOffer(offer: offer) { (response) in
            
            guard let responseForOffer = response as? OfferResponse else {
                self.activityIndicator.stopAnimating()
                showAlert(self, ERROR, OFFER_CREATE_DEMAND_FAILED)
                return
            }
            
            if responseForOffer.totalRows != 0
            {
                var imageArr: [UIImage] = []
                var index = 0
                while index < self.ImageDictionary.count
                {
                    if let image = self.ImageDictionary["\(index)"] as? UIImage
                    {
                        imageArr.append(image)
                    }
                    index += 1
                }
                
                if imageArr.count > 0 || self.videoUrl != nil
                {
                    let offerId = UserDefaults.standard.value(forKey: "offerId") as! String
                    
                    var videoData:NSData?
                    
                    if self.videoUrl != nil
                    {
                        videoData = NSData(contentsOf: self.videoUrl!)
                    }
                    else
                    {
                        videoData = nil
                    }
                    
                    ApiService.requestForUploadOffer(imageArr, Video: videoData, strURL: URL_UPLOAD_IMAGES_OFFER + offerId, params: nil, headers: nil, success: { (response) in
                        
                        self.ImageDictionary.removeAll()
                        self.uploadImageCollectionView.reloadData()
                        self.ivThumbnailVideo.image = UIImage(named: "Add")
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WholesalerThanksViewControllerID") as! ThanksOfferViewController
                        self.present(vc, animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                        
                    }, failure: { (error) in
                        
                        print("Error while uploading Images")
                    })
                }
                else
                {
                    self.ImageDictionary.removeAll()
                    self.uploadImageCollectionView.reloadData()
                    self.ivThumbnailVideo.image = UIImage(named: "Add")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "WholesalerThanksViewControllerID") as! ThanksOfferViewController
                    self.present(vc, animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                }
            }
            else
            {
                self.activityIndicator.stopAnimating()
                showAlert(self, ERROR, OFFER_CREATE_DEMAND_FAILED)
                return
            }
            
            
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
                          quantyPerMonth: demand.quantyPerMonth == nil ? 0 : demand.quantyPerMonth!,
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
    
}
