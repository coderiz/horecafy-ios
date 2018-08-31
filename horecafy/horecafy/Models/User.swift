import Foundation

enum TypeOfUser: Int {
    case CUSTOMER = 1
    case WHOLESALER = 0
    case UNKNOWN = -1
}

struct CustomerRequest: Codable {
    var hiddenId: String!
    var id: String!
    var VAT: String!
    var email: String!
    var name: String!
    var typeOfBusinessId: Int!
    var contactName: String!
    var contactEmail: String!
    var contactMobile: String!
    var address: String!
    var city: String!
    var zipCode: String!
    var province: String!
    var country: String!
    var createdOn: Date!
    var visible: Bool!
    
    init(user: User) {
        self.hiddenId = user.hiddenId
        self.id = user.id
        self.VAT = user.VAT
        self.email = user.email
        self.name = user.name
        self.typeOfBusinessId = user.typeOfBusinessId
        self.contactName = user.contactName
        self.contactEmail = user.contactEmail
        self.contactMobile = user.contactMobile
        self.address = user.address
        self.city = user.city
        self.zipCode = user.zipCode
        self.province = user.province
//        self.country = user.country
        self.createdOn = user.createdOn
        self.visible = user.visible
    }
}

struct User: Codable {
    let hiddenId: String
    let id: String
    let VAT: String
    let email: String
    let name: String
    let typeOfBusinessId: Int
    let contactName: String
    let contactEmail: String
    let contactMobile: String
    let address: String
    let city: String
    let zipCode: String
    let province: String
//    let country: String
    let createdOn: Date
    let visible: Bool
}

struct ContactData {
    let contactName: String
    let contactMobile: String
}

struct AddressData {
    let address: String
    let city: String
    let zipCode: String
    let province: String
    let country: String
}

struct CustomerResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String?
    let data: [User]
}

struct WholeSalerResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [User]
}

struct LoginResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [User]
}

struct ForgotResponse:Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [PasswordRecoveryDetail]
}

struct PasswordRecoveryDetail:Codable {
    let typeUser: Bool
    let userId: String
    let token: String
}

struct ProvinceData: Codable{
    let id: String
    let province: String
}

struct ProvinceListResponse: Codable
{
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String?
    let message: String?
    let data: [ProvinceData]
}
