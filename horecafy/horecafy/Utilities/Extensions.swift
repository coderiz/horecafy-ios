import UIKit

extension UITextField {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.tag == 55555 {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    func setDropDownButton() {
        
        let arrow = UIImageView(image: UIImage(named: "arrDropDown"))
        arrow.backgroundColor = UIColor.clear
        arrow.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        arrow.contentMode = UIViewContentMode.center
        
        let RightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 40, height: 40))
        RightView.backgroundColor = UIColor.clear
        RightView.addSubview(arrow)
        self.rightView = RightView
        self.rightViewMode = UITextFieldViewMode.always
    }
    
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let iso8601FullBis: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Date {
    
    var ToString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
    
    func getDeliveryDate() -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: self)
        return strDate
    }

    func getDeliveryTime() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        let strTime = dateFormatter.string(from: self)
        return strTime
    }

}

extension String {
    var removingSpacesAndNewLines: String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
}

extension DispatchQueue {
    static func delay(_ delay: DispatchTimeInterval, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}
