//
//  ReviewOfferProductViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 11/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ReviewOfferProductViewController: UIViewController {

    @IBOutlet weak var tblProducts: UITableView!
    
    var arrProducts:[ProductObj] = []
    var arrOpenedDistributor:[Int64] = []
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var isProcessRunning:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loading.hidesWhenStopped = true
        
        self.tblProducts.estimatedRowHeight = 160
        self.tblProducts.rowHeight = UITableViewAutomaticDimension
        self.tblProducts.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func selectSection(_ sender:UIButton) {
        let ProductID = AppDelegate.sharedInstance.arrProductDistributor[sender.tag - 1].id
        
        if self.arrOpenedDistributor.contains(ProductID) {
            let indexOF = self.arrOpenedDistributor.index(of: ProductID)
            self.arrOpenedDistributor.remove(at: indexOF!)
        }
        else if !self.arrOpenedDistributor.contains(ProductID) {
            self.arrOpenedDistributor.append(ProductID)
        }
        
        self.tblProducts.reloadData()
    }
    
    @objc func declineOffer(sender: MyButton)
    {
        let distributors = AppDelegate.sharedInstance.arrProductDistributor[sender.section].Distributors[sender.row]
        
        ApiService.instance.declineOffer(offerId: String(distributors.id), completion: { result in
            guard let ResponseforDecline:DeclineOfferResponse = result as? DeclineOfferResponse else {
                showAlert(self, ERROR, FAILURE_TO_DECLINE)
                return
            }
            if ResponseforDecline.totalRows != 0 {
                
                AppDelegate.sharedInstance.arrProductDistributor[sender.section].Distributors.remove(at: sender.row)
         
                self.tblProducts.reloadData()
                
                NotificationCenter.default.post(name: Notification.Name("getOffers"), object: nil)
            }
        })
    
    }

}

//MARK:- UITableview Datasource & Delegate Methods
extension ReviewOfferProductViewController :UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppDelegate.sharedInstance.arrProductDistributor.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let SectionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40.0))
        SectionView.backgroundColor = UIColor.white
        
        let lblSectionTitle = UILabel(frame: CGRect(x: 15, y: 10, width: UIScreen.main.bounds.width - 75, height: 20))
        lblSectionTitle.textAlignment = .left
        lblSectionTitle.font = UIFont(name: "Helvetica", size: 14.0)
        lblSectionTitle.textColor = UIColor.black
        lblSectionTitle.text = AppDelegate.sharedInstance.arrProductDistributor[section].name
        
        let imgArrow = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 12, width: 15, height: 15))
        imgArrow.backgroundColor = UIColor.clear
        
        if self.arrOpenedDistributor.contains(AppDelegate.sharedInstance.arrProductDistributor[section].id) {
            imgArrow.image = UIImage(named: "UpArrow")
        }
        else {
            imgArrow.image = UIImage(named: "DownArrow")
        }
        
        let btnSection = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40.0))
        btnSection.backgroundColor = UIColor.clear
        btnSection.tag = section + 1
        btnSection.addTarget(self, action: #selector(selectSection(_:)) , for: .touchUpInside)
        
        SectionView.addSubview(lblSectionTitle)
        SectionView.addSubview(imgArrow)
        SectionView.addSubview(btnSection)
        
        return SectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
   
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let FooterSectionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40.0))
        FooterSectionView.backgroundColor = UIColor.white
        
        return FooterSectionView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var RowCount:Int = 0
        let ProductID = AppDelegate.sharedInstance.arrProductDistributor[section].id
        if self.arrOpenedDistributor.contains(ProductID) {
            RowCount = AppDelegate.sharedInstance.arrProductDistributor[section].Distributors.count
        }
        return RowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let TblCell = self.tblProducts.dequeueReusableCell(withIdentifier: "ReviewOfferProductTblCell") as! ReviewOfferProductTblCell
        
        let Distriutor:OfferObject = AppDelegate.sharedInstance.arrProductDistributor[indexPath.section].Distributors[indexPath.row]
        TblCell.ContactDelegate = self
        TblCell.lblProductName.text = Distriutor.WholeSaler.name
        TblCell.lblBrand.text = Distriutor.brand
        TblCell.lblPrice.text = "\(Distriutor.offerPrice)"
        TblCell.lblFormat.text = "\(Distriutor.fomat)"
        TblCell.lblComments.text = "\(Distriutor.comments)" == "" ? " " : "\(Distriutor.comments)"
        
        TblCell.btnDecline.section = indexPath.section
        TblCell.btnDecline.row = indexPath.row
        TblCell.btnDecline.addTarget(self, action: #selector(declineOffer(sender:)), for: .touchUpInside)
        
        if Distriutor.images != ""
        {
            TblCell.btnPreviewImages.isHidden = false
            TblCell.btnPreviewImages.row = indexPath.row
            TblCell.btnPreviewImages.section = indexPath.section
            TblCell.btnPreviewImages.addTarget(self, action: #selector(previewImage(sender:)), for: .touchUpInside)
        }
        else
        {
            TblCell.btnPreviewImages.isHidden = true
        }
        
        if Distriutor.video != ""
        {
            TblCell.btnPreviewVideo.isHidden = false
            TblCell.btnPreviewVideo.row = indexPath.row
            TblCell.btnPreviewVideo.section = indexPath.section
            TblCell.btnPreviewVideo.addTarget(self, action: #selector(previewVideo(sender:)), for: .touchUpInside)
        }
        else
        {
            TblCell.btnPreviewVideo.isHidden = true
        }
        
        TblCell.selectionStyle = .none
        return TblCell
    }
    
    @objc func previewImage(sender: MyButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ShowPreviewPopupVC") as! ShowPreviewPopupVC
        
        let Distriutor:OfferObject = AppDelegate.sharedInstance.arrProductDistributor[sender.section].Distributors[sender.row]
        if Distriutor.images != ""
        {
            let images = Distriutor.images
            let imageArr = images.components(separatedBy: ",")
            VC.arrImages = imageArr
        }
        VC.showImageVideo = "showImages"
        
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func previewVideo(sender: MyButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ShowPreviewPopupVC") as! ShowPreviewPopupVC
        
        let Distriutor:OfferObject = AppDelegate.sharedInstance.arrProductDistributor[sender.section].Distributors[sender.row]
        if Distriutor.video != ""
        {
            VC.strVideo = Distriutor.video
        }
        VC.showImageVideo = "showVideo"
        
        self.present(VC, animated: true, completion: nil)
    }
    
}

//MARK:- Contact Distributor Delegate
extension ReviewOfferProductViewController : ContactDistributorDelegate {

    func ContactDistributor(CustomCell: UITableViewCell)
    {
        if self.loading.isAnimating == false {
            let Index:IndexPath = self.tblProducts.indexPath(for: CustomCell)!
            let SelectedDistributorID = AppDelegate.sharedInstance.arrProductDistributor[Index.section].Distributors[Index.row].WholeSaler.id
            self.loading.startAnimating()
            ApiService.instance.ContactDistributor(Wholesaler_ID: SelectedDistributorID, Customer_ID: loadUser().id) { (response) in
                self.loading.stopAnimating()
                guard let ResponseforOrderRequest:ContactDistributorResponse = response as? ContactDistributorResponse else {
                    showAlert(self, ERROR, FAILURE_TO_CONTACT)
                    return
                }
                if ResponseforOrderRequest.totalRows != 0 {
                    self.performSegue(withIdentifier: CONTACT_DISTRIBUTOR_THANK_YOU, sender: nil)
                }
            }
        }
    }

}
