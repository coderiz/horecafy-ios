import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var lblFamilyCounter: UILabel!
    
    @IBOutlet var btnselect: UIButton!
    
    override func awakeFromNib() {
        self.lblFamilyCounter.layer.cornerRadius = 15.0
        self.lblFamilyCounter.layer.masksToBounds = true
    }
    
}
