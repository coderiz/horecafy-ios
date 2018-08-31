//
//  BussinessRequirementFormViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import MediaPlayer
import AVFoundation

class BussinessRequirementFormViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtRestaurantType: UITextField!
    @IBOutlet weak var txtComments: UITextView!
    @IBOutlet var RestaurantTypePicker: UIPickerView!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    @IBOutlet weak var uploadImageCollectionView: UICollectionView!
    @IBOutlet weak var ivThumbnailVideo: UIImageView!
    
    @IBOutlet weak var btnSendPraposal: UIButton!
    
    var typeOfBusiness = [TypeOfBusiness]()
    var typeOfBusinessSelected: TypeOfBusiness?
    
    var ImageDictionary : [String : UIImage] = [:]
    var currentPickIndex: Int = -1
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    
    var videoUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.getBusinessTypes()
        print("\(Date().timeIntervalSince1970).mp4")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //IBAction Methods
    
    @IBAction func btnSelectRestaurantType(_ sender: Any) {
        self.txtRestaurantType.becomeFirstResponder()
        
    }
    
    @IBAction func btnSendPropasal(_ sender: Any) {
        self.view.endEditing(true)
        
        if let BusinessPraposalReq = self.BussinessPraposalRequest() {
            self.loading.startAnimating()
            self.btnSendPraposal.isEnabled = false
            
            ApiService.instance.SendPraposal(Praposal: BusinessPraposalReq, completion: { (response) in
                
                guard let ResponseforPraposal:BusinessPraposalResponse = response as? BusinessPraposalResponse else {
                    self.loading.stopAnimating()
                    self.btnSendPraposal.isEnabled = true
                    showAlert(self, ERROR, FAILURE_TO_SEND_PRAPOSAL)
                    
                    return
                }
                
                if ResponseforPraposal.totalRows != 0 {
                    
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
                        let groupId = UserDefaults.standard.value(forKey: "groupId") as? String
                        
                        var videoData:NSData?
                        
                        if self.videoUrl != nil
                        {
                            videoData = NSData(contentsOf: self.videoUrl!)
                        }
                        else
                        {
                            videoData = nil
                        }
                        
                        ApiService.requestForUploadProduct(imageArr, Video: videoData, strURL: URL_UPLOAD_IMAGES_BUSINESS_VISIT + groupId!, params: nil, headers: nil, success: { (response) in
                            
                            self.loading.stopAnimating()
                            showAlert(self, SUCCESS, PRAPOSAL_SENT_SUCCESSFULLY)
                            
                            self.btnSendPraposal.isEnabled = true
                            self.txtRestaurantType.text = ""
                            self.txtZipcode.text = ""
                            self.txtComments.text = ""
                            self.typeOfBusinessSelected = nil
                            
                            self.ImageDictionary.removeAll()
                            self.uploadImageCollectionView.reloadData()
                            self.ivThumbnailVideo.image = UIImage(named: "Add")

                        }, failure: { (error) in
                            
                            print("Error while uploading Images")
                        })
                    }
                    else
                    {
                        self.loading.stopAnimating()
    
                        showAlert(self, SUCCESS, PRAPOSAL_SENT_SUCCESSFULLY)
                        
                        self.btnSendPraposal.isEnabled = true
                        self.txtRestaurantType.text = ""
                        self.txtZipcode.text = ""
                        self.txtComments.text = ""
                        self.typeOfBusinessSelected = nil
                        
                        self.ImageDictionary.removeAll()
                        self.uploadImageCollectionView.reloadData()
                        self.ivThumbnailVideo.image = UIImage(named: "Add")
                    }
                    
                }
                else {
                    showAlert(self, ERROR, ResponseforPraposal.message)
                    self.btnSendPraposal.isEnabled = true
                }
            })
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


//MARK:- Private Methods
extension BussinessRequirementFormViewController {
    
    func setLayout() {
        
//        self.title = "hacer un pedido"
        self.loading.hidesWhenStopped = true
        self.txtComments.layer.cornerRadius  = 5.0
        self.txtComments.layer.borderColor = UIColor.lightGray.cgColor
        self.txtComments.layer.borderWidth = 1.0
        self.txtComments.layer.masksToBounds = true
        self.txtRestaurantType.tag = 55555
        self.RestaurantTypePicker.translatesAutoresizingMaskIntoConstraints = false
        self.txtRestaurantType.inputView = self.RestaurantTypePicker
        self.txtRestaurantType.delegate = self
        self.txtRestaurantType.setDropDownButton()
        self.loading.hidesWhenStopped = true
        
    }
    
    func BussinessPraposalRequest() -> BusinessPraposal? {
        
        guard let RestaurantZipcode = self.txtZipcode.text, self.txtZipcode.text != "" else {
                showAlert(self, WARNING, ZIP_CODE_MISSING)
                return nil
            }
    
//        guard let typeOfBusiness = typeOfBusinessSelected else {
//            showAlert(self, WARNING, MISSING_RESTAURANT_TYPE)
//            return nil
//        }
        
        var TypeOfBusinessId:Int = 0
        
        if let TypeOfBusiness = typeOfBusinessSelected {
            TypeOfBusinessId = TypeOfBusiness.id
        }
        
        guard let Comment = self.txtComments.text, self.txtComments.text != "" else {
            showAlert(self, WARNING, MISSING_COMMENTS)
            return nil
        }
 
        let MakeSendPraposal = BusinessPraposal(WholesalerId: Int(userId), typeOfBusinessId: TypeOfBusinessId, comments: Comment, zipcode: RestaurantZipcode)
        
        return MakeSendPraposal
    }
    
    func getBusinessTypes(){
        self.loading.startAnimating()
        ApiService.instance.getTypeOfBusiness { (result) in
            self.loading.stopAnimating()
            guard let result: [TypeOfBusiness] = result as? [TypeOfBusiness] else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            self.typeOfBusiness = result
            self.typeOfBusiness.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.RestaurantTypePicker.reloadAllComponents()
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
    
}

//MARK:- UITextfieldDelegate Methods

extension BussinessRequirementFormViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtRestaurantType {
            if self.typeOfBusiness.count > 0 && self.txtRestaurantType.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                self.typeOfBusinessSelected = typeOfBusiness[0]
                self.txtRestaurantType.text = self.typeOfBusinessSelected?.name
            }
        }
        return true
    }
    
}

//MARK:- UIPickerview Datasource & Delegate Methods

extension BussinessRequirementFormViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.typeOfBusiness.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return  self.typeOfBusiness[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if typeOfBusiness.count > 0 {
            self.typeOfBusinessSelected = typeOfBusiness[row]
            txtRestaurantType.text = self.typeOfBusinessSelected?.name
        }
//        self.selectedDistributorId = self.arrDistributors[row].hiddenId
    }
}


