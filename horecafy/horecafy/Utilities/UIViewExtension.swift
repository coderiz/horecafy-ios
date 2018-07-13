import UIKit

extension UIView {
    public static func initFromXib<T: UIView>(_ type: T.Type) -> T {
        let nibName = String(describing: T.self)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T else {
            fatalError("Can not create view with nib name: \(nibName)")
        }
        return view
    }
}

