import UIKit

class WholeSalerListCell: UITableViewCell {
    var list: ListsByWholeSaler?
    var family: Family?
    var parentTableViewController: WholeSalerShowListsViewController?
    @IBOutlet weak var familyName: UILabel!
    @IBAction func deleteTapped(_ sender: Any) {
        self.parentTableViewController?.deleteItem(cell: self)
    }
    
    func configureCell(list: ListsByWholeSaler)  {
        self.list = list
        self.family = list.family
        self.familyName.text = family?.name
    }
}
