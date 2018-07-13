import Foundation
import Alamofire

extension String: Error{}
class ApiService {
    
    static let instance = ApiService()
    var SelectedForgotUserType:Int = -1
    
    func shareDemand(demandId: String,completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_DEMANDS_SHARE)/\(demandId)").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let res: DemandByCustomerResponse = try! JSONDecoder().decode(DemandByCustomerResponse.self, from: jsonData)
                completion(res)
                
            } else {
                completion(nil)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getCategoriesDemandWithFamilyCount(customerId: Int64,completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_CATEGORIES_DEMAND_FAMILYC_COUNT)?customerId=\(customerId)").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let res: CategoryWithFamilyCountResponse = try! JSONDecoder().decode(CategoryWithFamilyCountResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getCategoriesWholesalerListWithFamilyCount(wholesalerId: Int64,completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_CATEGORIES_WHOLESALER_FAMILY_COUNT)?wholesalerId=\(wholesalerId)").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let res = try! JSONDecoder().decode(CategoryWithFamilyCountResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func deleteList(listId: Int, completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_WHOLESALER_LIST)/\(listId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: WholeSalerListResponse = try! decoder.decode(WholeSalerListResponse.self, from: jsonData)
                
                completion(res.data)
                
            } else {
                completion(nil)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func deleteDemand(demandId: Int, completion: @escaping CompletionHandler) {
    
        Alamofire.request("\(URL_DEMAND)/\(demandId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: DemandResponse = try! decoder.decode(DemandResponse.self, from: jsonData)
                
                completion(res.data)
                
            } else {
                completion(nil)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getListsByWholeSaler(wholeSalerId: Int64, categoryId: Int, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_WHOLESALER)/\(wholeSalerId)/lists?categoryId=\(categoryId)&borrado=0").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601FullBis)
                let res: ListsByWholeSalerResponse = try! decoder.decode(ListsByWholeSalerResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getWholeSalerList(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_WHOLESALER, method: .get).responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601FullBis)
                let res: WholesalerResponseData = try! decoder.decode(WholesalerResponseData.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func getOfferList(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_OFFER, method: .get).responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601FullBis)
                let res: ReviewOfferResponse = try! decoder.decode(ReviewOfferResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    
    func getDemandsWithOffers(customerId: Int64, categoryId: Int, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_CUSTOMER)/\(customerId)/demandsWithOffers?categoryId=\(categoryId)&borrado=0&sentTo=1").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601FullBis)
                let res = try! decoder.decode(DemandByCustomerResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getDemandsByCustomer(customerId: Int64, categoryId: Int, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_CUSTOMER)/\(customerId)/demands?categoryId=\(categoryId)&sentTo=0&borrado=0").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601FullBis)
                let res: DemandByCustomerResponse = try! decoder.decode(DemandByCustomerResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getDemandsByWholeSaler(wholesalerId: Int64, categoryId: Int, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_WHOLESALER)/\(wholesalerId)/demands?categoryId=\(categoryId)&sentTo=0&borrado=0").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res = try! decoder.decode(DemandByWholeSalerResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getWholeSalerBusinessNotification(wholesalerId: String , completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_GET_WHOLESALER_BUSINESS_NOTIFICATION)/\(wholesalerId)").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res = try! decoder.decode(BusinessNotificationResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    func getCustomerAvailibility(CustomerId: String , completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_CUSTOMER)/\(CustomerId)/availability").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res = try! decoder.decode(AvailibilityResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getCustomerBusinessNotification(CustomerId: String , completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_GET_CUSTOMER_BUSINESS_NOTIFICATION)/\(CustomerId)").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res = try! decoder.decode(BusinessNotificationResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    func Accept_RejectBusinessPraposal(isAccept:Bool, NotificationID: String , completion: @escaping CompletionHandler) {
        var Accept_Reject_URL = ""
        if isAccept == true {
            Accept_Reject_URL = URL_ACCEPT_PRAPOSAL
        }
        else if isAccept == false {
            Accept_Reject_URL = URL_REJECT_PRAPOSAL
        }
        
        Alamofire.request("\(Accept_Reject_URL)/\(NotificationID)").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res = try! decoder.decode(BusinessPraposalResponse.self, from: jsonData)
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func SetTimeSlot(NotificationID:String, TimeSlot:String, completion: @escaping CompletionHandler) {
        
        var body:[String:Any] = [:]
        
        body["timeslot"] = TimeSlot
        
        Alamofire.request("\(URL_SET_TIMESLOT)/\(NotificationID)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: SetTimeSlotResponse = try! decoder.decode(SetTimeSlotResponse.self, from: jsonData)
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    
    func AddCustomerAvailibility(CustomerId:String, TimeSlot:String, completion: @escaping CompletionHandler) {
        
        var body:[String:Any] = [:]
        
        body["availability"] = TimeSlot
        
        Alamofire.request("\(URL_Add_AVAILIBILITY)/\(CustomerId)/availability", method: .put, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: SetTimeSlotResponse = try! decoder.decode(SetTimeSlotResponse.self, from: jsonData)
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    
    func getApprovedCustomerOffers(customerId: Int64, demandId: Int, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_CUSTOMER)/\(customerId)/offers?demandId=\(demandId)&borrado=0&approvedByCustomer=0").responseJSON { response in
            switch response.result {
            case .failure:
                completion(false)
                debugPrint(response.result.error as Any)
            case .success(let json):
                print(json)
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601FullBis)
                do {
                    let offerResponse = try decoder.decode(OfferCustomerResponse.self, from: jsonData)
                    completion(offerResponse.data)
                } catch let error {
                    debugPrint(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    func fetchInfoOffer(offerId: Int, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_OFFER)/\(offerId)").responseJSON { response in
            switch response.result {
            case .failure:
                completion(false)
                debugPrint(response.result.error as Any)
            case .success(let json):
                print(json)
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601FullBis)
                do {
                    let offerResponse = try decoder.decode(MakeOfferResponse.self, from: jsonData)
                    completion(offerResponse.data)
                } catch let error {
                    debugPrint(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    func customerAcceptOffer(offerId: Int, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_OFFER)accept/\(offerId)").responseJSON { response in
            switch response.result {
            case .failure:
                completion(false)
                debugPrint(response.result.error as Any)
            case .success(let json):
                print(json)
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601FullBis)
                do {
                    completion(true)
                } catch let error {
                    debugPrint(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    func createList(list: WholeSalerList, wholeSalerId: Int64, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "wholesalerId": wholeSalerId,
            "familyId": list.familyId,
            "brand": list.brand,
            "comments": list.comments
        ]
        
        Alamofire.request(URL_WHOLESALER_LIST, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            switch response.result {
            case .failure:
                completion(false)
                debugPrint("\(response.result.error ?? "URL_WHOLESALER_LIST Error")")
            case .success:
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let res: WholeSalerListResponse = try decoder.decode(WholeSalerListResponse.self, from: jsonData)
                    completion(res)
                } catch let error {
                    completion(false)
                    debugPrint("\(error)")
                }
            }
        }
    }
    
    func createCustomerFreeDemand(FreeDemand:CreateFreeDemand, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "customerId": FreeDemand.customerId,
            "demandText": FreeDemand.demandText]
        
        Alamofire.request(URL_FREE_DEMAND, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: FreeDemandResponse = try! decoder.decode(FreeDemandResponse.self, from: jsonData)
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    func createCustomerBusinessRequest(BusinessRequest: CustomerBusinessRequest, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "customerId": BusinessRequest.customerId,"productName": BusinessRequest.productName, "brand": BusinessRequest.brand, "consumption": BusinessRequest.consumption, "targetPrice": BusinessRequest.targetPrice, "success": BusinessRequest.MailFlag]
        
        Alamofire.request(URL_CUSTOMER_BUSINESS_REQUEST, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: BusinessRequestResponse = try! decoder.decode(BusinessRequestResponse.self, from: jsonData)
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    func createOrder(OrderRequest: MakeAnOrder, completion: @escaping CompletionHandler) {
        
        var body:[String:Any] = [:]
        
        body["customerId"] = OrderRequest.customerId
        body["wholesalerId"] = OrderRequest.WholesalerId
        body["products"] = OrderRequest.products
        body["deliveryDate"] = OrderRequest.deliveryDate
       
        
        if OrderRequest.deliveryTime != "" {
            body["deliveryTime"] = OrderRequest.deliveryTime
        }
        
        if OrderRequest.comments != "" {
             body["comments"] = OrderRequest.comments
        }
        
        Alamofire.request(URL_MAKE_ORDER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: MakeOrderResponse = try! decoder.decode(MakeOrderResponse.self, from: jsonData)
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func SendInvitation(Invitation: InviteDistributor, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "customerId": Invitation.customerId,
            "name": Invitation.name,
            "email": Invitation.email,
            "phone": Invitation.phone,
            "contact": Invitation.contact]
        
        Alamofire.request(URL_SEND_INVITATION, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
               
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: InvitationResoponse = try! decoder.decode(InvitationResoponse.self, from: jsonData)
                
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }

    func SendPraposal(Praposal: BusinessPraposal, completion: @escaping CompletionHandler) {
        
        var body: [String: Any] = [
            "wholesalerId": Praposal.WholesalerId,
            "typeOfBusinessId": Praposal.typeOfBusinessId,
            "comments": Praposal.comments]
        
        if Praposal.zipcode != "" {
            body["zipcode"] = Praposal.zipcode
        }
    
        Alamofire.request(URL_SEND_PRAPOSAL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: BusinessPraposalResponse = try! decoder.decode(BusinessPraposalResponse.self, from: jsonData)
                
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
    func ContactDistributor(Wholesaler_ID:String, Customer_ID:String , completion: @escaping CompletionHandler) {
        
        var body: [String: Any] = [
            "wholeSalerId": Wholesaler_ID,
            "customerId": Customer_ID]
        
        
        Alamofire.request(URL_CONTACT_DISTRIBUTOR, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res:ContactDistributorResponse = try! decoder.decode(ContactDistributorResponse.self, from: jsonData)
                
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }

    
    //MARK: Offers
    func createOffer(offer: Offer, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "customerId": offer.customerId,
            "demandId": offer.demandId,
            "wholesalerId": offer.wholesalerId,
            "quantyPerMonth": offer.quantyPerMonth,
            "typeOfFormatId": offer.typeOfFormatId,
            "offerPrice": offer.offerPrice,
            "brand": offer.brand,
            "fomat": offer.fomat,
            "comments": offer.comments,
        ]
        
        Alamofire.request(URL_OFFER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: OfferResponse = try! decoder.decode(OfferResponse.self, from: jsonData)
                
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func fetchOffers(userID: Int64, completion: @escaping CompletionHandler) {
         Alamofire.request("\(URL_FETCH_OFFERS)\(userID)").responseJSON { response in
            switch response.result {
            case .failure(let error):
                completion(false)
                debugPrint(error as Any)
            case .success(let json):
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let res = try! JSONDecoder().decode(CategoryWithFamilyCountResponse.self, from: jsonData)
                completion(res.data)
            }
        }
    }
    
    func updateUser(request: CustomerRequest, customer: Bool, completion: @escaping CompletionHandler) {
        let credentials = loadCredentials()
        let body: [String: Any] = [
            "hiddenId": request.hiddenId,
            "id": request.id,
            "VAT": request.VAT,
            "email": request.email.lowercased(),
            "password": credentials.password,
            "name": request.name,
            "typeOfBusinessId": request.typeOfBusinessId,
            "contactName": request.contactName,
            "contactEmail": request.email,
            "contactMobile": request.contactMobile,
            "address": request.address,
            "city": request.city,
            "zipCode": request.zipCode,
            "province": request.province,
            "country": request.country,
            "visible": true
        ]
        Alamofire.request(customer == true ? URL_CUSTOMER : URL_WHOLESALER, method: .put, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { response in
            switch response.result {
            case .failure(let error):
                completion(false)
                debugPrint(error as Any)
            case .success(let json):
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res = try! decoder.decode(CustomerResponse.self, from: jsonData)
                if let user = res.data.first {
                    storeUser(user: user)
                }
                completion(true)
            }
        }
    }
    
    func createDemand(demand: Demand, customerId: Int64, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "customerId": customerId,
            "familyId": demand.familyId,
            "quantyPerMonth": demand.quantyPerMonth,
            "typeOfFormatId": demand.typeOfFormatId,
            "targetPrice": demand.targetPrice,
            "brand": demand.brand,
            "format": demand.format,
            "comments": demand.comments
        ]
        
        Alamofire.request(URL_DEMAND, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: DemandResponse = try! decoder.decode(DemandResponse.self, from: jsonData)
                
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func getTypeOfBusiness(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_TYPE_OF_BUSINESS).responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let res: TypeOfBusinessResponse = try! JSONDecoder().decode(TypeOfBusinessResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
  
    func getCategories(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_CATEGORIES).responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let res: CategoryResponse = try! JSONDecoder().decode(CategoryResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getCategoryImage(categoryImage: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_CATEGORIES_IMAGE)/\(categoryImage)").response { (response) in
            if (response.error == nil) {
                if let data = response.data {
                    completion(data)
                }
                else {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        }
    }
    
    func getTypesOfFormat(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_TYPE_FORMAT).responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let res: TypeOfFormatResponse = try! JSONDecoder().decode(TypeOfFormatResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getFamilies(categoryId: Int, completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_FAMILIES)/?categoryId=\(categoryId)").responseJSON { response in
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let res: FamilyResponse = try! JSONDecoder().decode(FamilyResponse.self, from: jsonData)
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, typeUser: Int, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password,
            "typeUser": typeUser
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: LoginResponse = try! decoder.decode(LoginResponse.self, from: jsonData)
                
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func ForgotPassword(email: String, typeUser: Int, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "typeUser": typeUser]
        
        Alamofire.request(URL_FORGOT, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: ForgotResponse = try! decoder.decode(ForgotResponse.self, from: jsonData)
                
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }

    func ResetPassword(email: String, typeUser: Int, Token: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "typeUser": typeUser,
            "token": Token,
            "password": password
        ]
        
        Alamofire.request(URL_RESET_PASSWORD, method: .put, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: LoginResponse = try! decoder.decode(LoginResponse.self, from: jsonData)
                
                completion(res.data)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }

    
    
    func createWholeSaler(user: User, password: String, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "VAT": user.VAT,
            "email": user.email.lowercased(),
            "password": password,
            "name": user.name,
            "typeOfBusinessId": user.typeOfBusinessId,
            "contactName": user.contactName,
            "contactEmail": user.contactEmail,
            "contactMobile": user.contactMobile,
            "address": user.address,
            "city": user.city,
            "zipCode": user.zipCode,
            "province": user.province,
            "country": user.country
        ]
        
        Alamofire.request(URL_WHOLESALER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            switch response.result {
            case .failure(let error):
                completion(false)
                debugPrint(error.localizedDescription)
            case .success(let json):
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                do {
                    let res = try decoder.decode(WholeSalerResponse.self, from: jsonData)
                    completion(res)
                } catch let error {
                    completion(false)
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    func createCustomer(user: User, password: String, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "VAT": user.VAT,
            "email": user.email.lowercased(),
            "password": password,
            "name": user.name,
            "typeOfBusinessId": user.typeOfBusinessId,
            "contactName": user.contactName,
            "contactEmail": user.contactEmail,
            "contactMobile": user.contactMobile,
            "address": user.address,
            "city": user.city,
            "zipCode": user.zipCode,
            "province": user.province,
            "country": user.country
        ]
        
        Alamofire.request(URL_CUSTOMER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            response in
            
            if response.result.error == nil {
                
                guard let json = response.result.value else {
                    return completion(nil)
                }
                
                guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: json) as Data else {
                    return completion(nil)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let res: CustomerResponse = try! decoder.decode(CustomerResponse.self, from: jsonData)
                
                completion(res)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}
