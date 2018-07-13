import UIKit

class InitialViewController: UINavigationController {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupupGUI()
    }
    
    private func setupupGUI(){
        navigationBar.tintColor = .white
    }
}
