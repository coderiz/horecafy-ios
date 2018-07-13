//
//  ReviewOfferViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 11/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class ReviewOfferViewController: UIViewController {

    
    @IBOutlet weak var Loading: UIActivityIndicatorView!
    
    @IBOutlet weak var MenuCollectionView: UICollectionView!
    
    var arrMenu:[String] = []
    var arrMenuImages:[String] = []
    var arrMaster:[OfferObject] = []
    
    var arrDistributor:[DistributorObj] = []
    var arrProductDistributor:[ProductObj] = []
    
    var arrProducts:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        
        self.getOffers()
        // Do any additional setup after loading the view.
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


//Private Methods

extension ReviewOfferViewController {
    
    func setLayout() {
        self.title = "Revisar ofertas"
        arrMenu = ["Distribuidor","Producto"]
        arrMenuImages = ["icon_Distributor","icon_Product"]
        self.Loading.hidesWhenStopped = true
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == REVIEW_OFFERS_DISTRIBUTOR_SEGUE {
            let vc = segue.destination as! ReviewOfferDistributorViewController
            vc.arrDistributors = self.arrDistributor
            vc.arrOffers = self.arrMaster
        }
        else if segue.identifier == REVIEW_OFFERS_PRODUCT_SEGUE {
            let vc = segue.destination as! ReviewOfferProductViewController
            vc.arrProducts = self.arrProductDistributor
//            vc.arrOffers = self.arrMaster
        }
    }

    
    func getOffers() {
        self.Loading.startAnimating()
        ApiService.instance.getOfferList(completion: { (result) in
                self.Loading.stopAnimating()
            guard let result: [OfferObject] = result as? [OfferObject] else {
                print("NO lists were loaded from api")
                return
            }
            
            self.arrMaster = result
            self.Build_Data_Structure()
        })
    }
    
    func Build_Data_Structure() {
        
        var arrDistributorsID:[Int64] = []
        var arrProductID:[Int64] = []
        
        var arrProductDist:[ProductObj] = []
        var arrDistributors:[DistributorObj] = []
        
        for SingleOffer in arrMaster {
            let ID = SingleOffer.WholeSaler.id
            let HiddenId = SingleOffer.WholeSaler.hiddenId
            let Name = SingleOffer.WholeSaler.name
            
            let ProductID = SingleOffer.Product.id
            let ProductName = SingleOffer.Product.name
            
            if arrProductID.contains(SingleOffer.Product.id) {
                var DistributorIndex:Int = 0
                for SingleProduct in arrProductDist {
                    if SingleProduct.id == SingleOffer.Product.id {
                        var Distributors = SingleProduct.Distributors
                        Distributors.append(SingleOffer)
                        let Product = ProductObj(id: ProductID, name: ProductName, Distributors: Distributors)
                        arrProductDist[DistributorIndex] = Product
                    }
                    DistributorIndex += 1
                }
            }
            else if !arrProductID.contains(SingleOffer.Product.id) {
                let Product = ProductObj(id: ProductID, name: ProductName, Distributors: [SingleOffer])
                arrProductDist.append(Product)
                arrProductID.append(SingleOffer.Product.id)
            }
            
            if arrDistributorsID.contains(SingleOffer.WholeSaler.hiddenId) {
                var DistributorIndex:Int = 0
                for SingleDistributor in arrDistributors {
                    if SingleDistributor.hiddendId == SingleOffer.WholeSaler.hiddenId {
                        var Products = SingleDistributor.Products
                        Products.append(SingleOffer)
                        let Distributor = DistributorObj(hiddendId: HiddenId, id: ID, name: Name, Products: Products)
                        arrDistributors[DistributorIndex] = Distributor
                    }
                    DistributorIndex += 1
                }
            }
            else if !arrDistributorsID.contains(SingleOffer.WholeSaler.hiddenId) {
                let Distributor = DistributorObj(hiddendId: HiddenId, id: ID, name: Name, Products: [SingleOffer])
                arrDistributors.append(Distributor)
                arrDistributorsID.append(SingleOffer.WholeSaler.hiddenId)
            }
            
        }
        
        self.arrProductDistributor = arrProductDist
        self.arrDistributor = arrDistributors
        print(self.arrDistributor)
    }
    
}


//UICollectionview Datasource & Delegate Methods

extension ReviewOfferViewController: UICollectionViewDataSource, UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout {
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewOfferCollectionCell", for: indexPath) as! ReviewOfferCollectionCell
       // cell.contentView.backgroundColor = UIColor.yellow
        cell.OfferImage.image = UIImage(named: self.arrMenuImages[indexPath.item])
        cell.lblOfferName.text = self.arrMenu[indexPath.item]
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            self.performSegue(withIdentifier: REVIEW_OFFERS_DISTRIBUTOR_SEGUE, sender: nil)
        case 1:
            self.performSegue(withIdentifier: REVIEW_OFFERS_PRODUCT_SEGUE, sender: nil)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthHeight = (UIScreen.main.bounds.size.width - 20) / 2
        //            ([[UIScreen mainScreen]bounds].size.width / 3 ) - 18;

        return CGSize(width: widthHeight, height: widthHeight + 50.0)
    }

    
    
}
