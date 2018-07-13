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
        
        self.tblProducts.estimatedRowHeight = 135
        self.tblProducts.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func selectSection(_ sender:UIButton) {
        let ProductID = self.arrProducts[sender.tag - 1].id
        
        if self.arrOpenedDistributor.contains(ProductID) {
            let indexOF = self.arrOpenedDistributor.index(of: ProductID)
            self.arrOpenedDistributor.remove(at: indexOF!)
        }
        else if !self.arrOpenedDistributor.contains(ProductID) {
            self.arrOpenedDistributor.append(ProductID)
        }
        
        self.tblProducts.reloadData()
    }

}



//MARK:- UITableview Datasource & Delegate Methods

extension ReviewOfferProductViewController :UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrProducts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let SectionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40.0))
        SectionView.backgroundColor = UIColor.white
        
        let lblSectionTitle = UILabel(frame: CGRect(x: 15, y: 10, width: UIScreen.main.bounds.width - 75, height: 20))
        lblSectionTitle.textAlignment = .left
        lblSectionTitle.font = UIFont(name: "Helvetica", size: 14.0)
        lblSectionTitle.textColor = UIColor.black
        lblSectionTitle.text = self.arrProducts[section].name
        
        let imgArrow = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 12, width: 15, height: 15))
        imgArrow.backgroundColor = UIColor.clear
        
        if self.arrOpenedDistributor.contains(self.arrProducts[section].id) {
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
        let ProductID = self.arrProducts[section].id
        if self.arrOpenedDistributor.contains(ProductID) {
            RowCount = self.arrProducts[section].Distributors.count
        }
        return RowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let TblCell = self.tblProducts.dequeueReusableCell(withIdentifier: "ReviewOfferProductTblCell") as! ReviewOfferProductTblCell
        
        let Distriutor:OfferObject = self.arrProducts[indexPath.section].Distributors[indexPath.row]
        TblCell.ContactDelegate = self
        TblCell.lblProductName.text = Distriutor.WholeSaler.name
        TblCell.lblBrand.text = Distriutor.brand
        TblCell.lblPrice.text = "\(Distriutor.offerPrice)"
        TblCell.lblFormat.text = "\(Distriutor.fomat)"
        TblCell.lblComments.text = "\(Distriutor.comments)" == "" ? " " : "\(Distriutor.comments)"
        
        TblCell.selectionStyle = .none
        return TblCell
    }
    
    
}


//MARK:- Contact Distributor Delegate


extension ReviewOfferProductViewController : ContactDistributorDelegate {

    func ContactDistributor(CustomCell: UITableViewCell) {
        
        if self.loading.isAnimating == false {
            let Index:IndexPath = self.tblProducts.indexPath(for: CustomCell)!
            let SelectedDistributorID = self.arrProducts[Index.section].Distributors[Index.row].WholeSaler.id
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
