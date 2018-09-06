//
//  ReviewOfferDistributorDetailViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 11/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ReviewOfferDistributorDetailViewController: UIViewController {
    
    @IBOutlet weak var tblDistributors: UITableView!
    
    @IBOutlet weak var lblDistributorName: UILabel!
    
    var Distributor:DistributorObj!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var arrProducts:[OfferObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBAction Methods
    @IBAction func btnContactDistributor(_ sender: Any) {
        if self.loading.isAnimating == false {
            self.loading.startAnimating()
            ApiService.instance.ContactDistributor(Wholesaler_ID: Distributor.id, Customer_ID: loadUser().id) { (response) in
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
    
    @objc func declineOffer(sender: UIButton)
    {
        ApiService.instance.declineOffer(offerId: self.arrProducts[sender.tag].id, completion: { result in
            guard let ResponseforDecline:DeclineOfferResponse = result as? DeclineOfferResponse else {
                showAlert(self, ERROR, FAILURE_TO_DECLINE)
                return
            }
            if ResponseforDecline.totalRows != 0 {
                self.arrProducts.remove(at: sender.tag)
                self.tblDistributors.reloadData()
                NotificationCenter.default.post(name: Notification.Name("getOffers"), object: nil)
            }
        })
        
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
extension ReviewOfferDistributorDetailViewController {
    
    func setLayout() {
        
        self.lblDistributorName.text = Distributor.name
        self.arrProducts = Distributor.Products
        
        self.tblDistributors.estimatedRowHeight = 160
        self.tblDistributors.rowHeight = UITableViewAutomaticDimension
        self.loading.hidesWhenStopped = true
        
        self.tblDistributors.tableFooterView = UIView()
        self.tblDistributors.reloadData()
    }
    
}

//MARK:- UITableview Datasource & Delegate Methods
extension ReviewOfferDistributorDetailViewController:UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let TblCell = self.tblDistributors.dequeueReusableCell(withIdentifier: "ReviewOfferDistributorDetailCell") as! ReviewOfferDistributorDetailCell
        
        TblCell.lblProductName.text = self.arrProducts[indexPath.row].Product.name
        
        TblCell.lblBrand.text = self.arrProducts[indexPath.row].brand
        TblCell.lblPrice.text = "\(self.arrProducts[indexPath.row].offerPrice)"
        
        TblCell.lblFormat.text = "\(self.arrProducts[indexPath.row].fomat)"
        
        TblCell.lblComments.text = "\(self.arrProducts[indexPath.row].comments)" == "" ? " " : "\(self.arrProducts[indexPath.row].comments)"
        
        TblCell.btnDecline.tag = indexPath.row
        TblCell.btnDecline.addTarget(self, action: #selector(declineOffer(sender:)), for: .touchUpInside)
        
        if self.arrProducts[indexPath.row].images != ""
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
        
        if self.arrProducts[indexPath.row].video != ""
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
        
        let Prodcts:OfferObject = AppDelegate.sharedInstance.arrDistributor[sender.section].Products[sender.row]
        if Prodcts.images != ""
        {
            let images = Prodcts.images
            let imageArr = images.components(separatedBy: ",")
            VC.arrImages = imageArr
        }
        VC.showImageVideo = "showImages"
        
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func previewVideo(sender: MyButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ShowPreviewPopupVC") as! ShowPreviewPopupVC
        
        let Distriutor:OfferObject = AppDelegate.sharedInstance.arrDistributor[sender.section].Products[sender.row]
        if Distriutor.video != ""
        {
            VC.strVideo = Distriutor.video
        }
        VC.showImageVideo = "showVideo"
        
        self.present(VC, animated: true, completion: nil)
    }
    
}
