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
        
        self.tblDistributors.estimatedRowHeight = 135
        self.tblDistributors.rowHeight = UITableViewAutomaticDimension
        self.loading.hidesWhenStopped = true
        
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
        
        TblCell.selectionStyle = .none
        return TblCell
    }
    
    
}
