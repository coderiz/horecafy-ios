//
//  ReviewOfferDistributorViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 11/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ReviewOfferDistributorViewController: UIViewController {

    
    @IBOutlet var TableHeaderView: UIView!
    
    @IBOutlet weak var lblSharedProducts: UILabel!
    @IBOutlet weak var lblOfferedProducts: UILabel!
    
    @IBOutlet weak var TblDistributors: UITableView!
    
    var arrOffers:[OfferObject] = []
    var arrDistributors:[DistributorObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.TblDistributors.reloadData()
        self.TblDistributors.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ReviewOfferDistributorViewController
{
    func setLayout()
    {
        self.lblSharedProducts.text = "\(AppDelegate.sharedInstance.arrProductDistributor.count)"
        self.lblOfferedProducts.text = "\(AppDelegate.sharedInstance.arrDistributor.count)"
        self.TblDistributors.tableHeaderView = self.TableHeaderView
        self.TblDistributors.tableFooterView = UIView()
    }
}

//MARK:- UITableview datasource & Delegate Methods
extension ReviewOfferDistributorViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppDelegate.sharedInstance.arrDistributor.count > 0 {
            return AppDelegate.sharedInstance.arrDistributor.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tblCell = UITableViewCell()
        if indexPath.row == 0 {
            
            let tblTitleCell = self.TblDistributors.dequeueReusableCell(withIdentifier: "ReviewOfferTitleTblCell") as! ReviewOfferTitleTblCell
            
            tblCell = tblTitleCell
        }
        else if indexPath.row > 0 {
            
            let tblReviewOfferCell = self.TblDistributors.dequeueReusableCell(withIdentifier: "ReviewOfferTblCell") as! ReviewOfferTblCell
            
            tblReviewOfferCell.lblProduct.text = AppDelegate.sharedInstance.arrDistributor[indexPath.row - 1].name
            
            tblReviewOfferCell.lblProductCount.text = "\(AppDelegate.sharedInstance.arrDistributor[indexPath.row - 1].Products.count)"
            
            tblCell = tblReviewOfferCell
        }
        
        tblCell.selectionStyle = .none
        return tblCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let ReviewOfferDetailPage = self.storyboard?.instantiateViewController(withIdentifier: "ReviewOfferDistributorDetailViewController") as!  ReviewOfferDistributorDetailViewController
        ReviewOfferDetailPage.Distributor = AppDelegate.sharedInstance.arrDistributor[indexPath.row - 1]
        self.navigationController?.pushViewController(ReviewOfferDetailPage, animated: true)
    }
    
}
