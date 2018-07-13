import Foundation
import UIKit

// Date
extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let finalDate = calendar.date(from:components)
        return finalDate!
    }
}

extension Double {
    func toString(_ numDecimals: Int) -> String {
        return String(format: "%.\(numDecimals)f",self)
    }
}
// Credentials
var isLoggedIn: Bool {
    get {
        return UserDefaults.standard.bool(forKey: LOGGED_IN_KEY)
    }
    set {
        UserDefaults.standard.set(newValue, forKey: LOGGED_IN_KEY)
    }
}

func loadUser() -> User {
    let userId = Int64(UserDefaults.standard.integer(forKey: USER_ID))
    let id = UserDefaults.standard.string(forKey: ID) ?? ""
    let email = UserDefaults.standard.string(forKey: USER_EMAIL) ?? ""
    let contactEmail = UserDefaults.standard.string(forKey: CONTACT_EMAIL) ?? ""
    let VAT = UserDefaults.standard.string(forKey: CIF_OR_NIF) ?? ""
    let contactName = UserDefaults.standard.string(forKey: CONTACT_NAME) ?? ""
    let telephone = UserDefaults.standard.string(forKey: TELEPHONE) ?? ""
    let address = UserDefaults.standard.string(forKey: ADDRESS) ?? ""
    let city = UserDefaults.standard.string(forKey: CITY) ?? ""
    let postalCode = UserDefaults.standard.string(forKey: POSTAL_CODE) ?? ""
    let province = UserDefaults.standard.string(forKey: PROVINCE) ?? ""
    let country = UserDefaults.standard.string(forKey: COUNTRY) ?? ""
    let businessName = UserDefaults.standard.string(forKey: BUSINNES_NAME) ?? ""
    let businessID = UserDefaults.standard.integer(forKey: BUSINNES_ID)

    return User(hiddenId: "\(userId)", id: id, VAT: VAT, email: email, name: businessName, typeOfBusinessId: businessID , contactName: contactName, contactEmail: contactEmail, contactMobile: telephone, address: address, city: city, zipCode: postalCode, province: province, country: country, createdOn: Date(), visible: true)
}

func storeUser(user: User) {
    UserDefaults.standard.set(user.contactEmail, forKey: CONTACT_EMAIL)
    UserDefaults.standard.set(user.id, forKey: ID)
    UserDefaults.standard.set(user.hiddenId, forKey: USER_ID)
    UserDefaults.standard.set(user.email, forKey: USER_EMAIL)
    UserDefaults.standard.set(user.VAT, forKey: CIF_OR_NIF)
    UserDefaults.standard.set(user.contactName, forKey: CONTACT_NAME)
    UserDefaults.standard.set(user.contactMobile, forKey: TELEPHONE)
    UserDefaults.standard.set(user.address, forKey: ADDRESS)
    UserDefaults.standard.set(user.city, forKey: CITY)
    UserDefaults.standard.set(user.zipCode, forKey: POSTAL_CODE)
    UserDefaults.standard.set(user.province, forKey: PROVINCE)
    UserDefaults.standard.set(user.country, forKey: COUNTRY)
    UserDefaults.standard.set(user.name, forKey: BUSINNES_NAME)
    UserDefaults.standard.set(user.typeOfBusinessId, forKey: BUSINNES_ID)
    isLoggedIn = true
}

func removeUser() {
    UserDefaults.standard.removeObject(forKey: CONTACT_EMAIL)
    UserDefaults.standard.removeObject(forKey: ID)
    UserDefaults.standard.removeObject(forKey: USER_ID)
    UserDefaults.standard.removeObject(forKey: USER_EMAIL)
    UserDefaults.standard.removeObject(forKey: USER_TYPE)
    UserDefaults.standard.removeObject(forKey: CIF_OR_NIF)
    UserDefaults.standard.removeObject(forKey: BUSINNES_NAME)
    UserDefaults.standard.removeObject(forKey: CONTACT_NAME)
    UserDefaults.standard.removeObject(forKey: TELEPHONE)
    UserDefaults.standard.removeObject(forKey: ADDRESS)
    UserDefaults.standard.removeObject(forKey: CITY)
    UserDefaults.standard.removeObject(forKey: POSTAL_CODE)
    UserDefaults.standard.removeObject(forKey: PROVINCE)
    UserDefaults.standard.removeObject(forKey: COUNTRY)
    UserDefaults.standard.removeObject(forKey: BUSINNES_NAME)
    UserDefaults.standard.removeObject(forKey: BUSINNES_ID)
    isLoggedIn = false
}

func storeCredentials(_ credentials: Credentials) {
    UserDefaults.standard.set(credentials.userId, forKey: USER_ID)
    UserDefaults.standard.set(credentials.email, forKey: USER_EMAIL)
    UserDefaults.standard.set(credentials.password, forKey: USER_PASSWORD)
    UserDefaults.standard.set(credentials.typeUser.rawValue, forKey: USER_TYPE)
    UserDefaults.standard.set(credentials.userId, forKey: USER_ID)
    isLoggedIn = true
}

func loadCredentials() -> Credentials {
    let userId: Int64 = Int64(UserDefaults.standard.integer(forKey: USER_ID))
    let email: String = UserDefaults.standard.string(forKey: USER_EMAIL) ?? ""
    let password: String = UserDefaults.standard.string(forKey: USER_PASSWORD) ?? ""
    let typeUser: Int = UserDefaults.standard.integer(forKey: USER_TYPE)
    return Credentials(userId: userId, email: email, password: password, typeUser: typeUser == 1 ? TypeOfUser.CUSTOMER : TypeOfUser.WHOLESALER)
}

func removeCredentials() {
    UserDefaults.standard.removeObject(forKey: USER_ID)
    UserDefaults.standard.removeObject(forKey: USER_EMAIL)
    UserDefaults.standard.removeObject(forKey: USER_PASSWORD)
    UserDefaults.standard.removeObject(forKey: USER_TYPE)
    isLoggedIn = false
}
// Custom Alert View
func showAlert(_ vc: UIViewController, _ titulo: String, _ mensaje: String, delegate: CustomerAlertView? = nil) {
    let customAlert = CustomerAlertViewController(titulo: titulo, mensaje: mensaje)
    customAlert.providesPresentationContextTransitionStyle = true
    customAlert.definesPresentationContext = true
    customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    customAlert.delegate = delegate
    vc.present(customAlert, animated: true, completion: nil)
}
// User account
var userContactData: ContactData?
var userAddressData: AddressData?
// Demands to share
var demandsToShare: [String] = []
