import UIKit

class InitialWholeSalerViewController: UINavigationController {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupupGUI()
    }
    
    private func setupupGUI(){
        navigationBar.tintColor = .white
    }
}
