//
//  Constants.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 12/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation


// API
let BASE_URL = "http://demo.aipxperts.com:4201"
//"https://horecafyapi.azurewebsites.net"
let API_VERSION = "v1"
let URL_TYPE_FORMAT = "\(BASE_URL)/api/\(API_VERSION)/type-format"
let URL_FAMILIES = "\(BASE_URL)/api/\(API_VERSION)/family"
let URL_CATEGORIES = "\(BASE_URL)/api/\(API_VERSION)/category"
let URL_CATEGORIES_IMAGE = "\(BASE_URL)/images/categories"
let URL_LOGIN = "\(BASE_URL)/api/\(API_VERSION)/login"
let URL_FORGOT = "\(BASE_URL)/api/\(API_VERSION)/password-reset"
let URL_RESET_PASSWORD = "\(BASE_URL)/api/\(API_VERSION)/password-reset"
let URL_TYPE_OF_BUSINESS = "\(BASE_URL)/api/\(API_VERSION)/type-business"
let URL_CUSTOMER = "\(BASE_URL)/api/\(API_VERSION)/customer"
let URL_WHOLESALER = "\(BASE_URL)/api/\(API_VERSION)/wholesaler"
let URL_WHOLESALER_LIST = "\(BASE_URL)/api/\(API_VERSION)/wholesaler-list"
let URL_DEMAND = "\(BASE_URL)/api/\(API_VERSION)/demand"
let URL_OFFER = "\(BASE_URL)/api/\(API_VERSION)/offer"
let URL_FETCH_OFFERS = "\(BASE_URL)/api/\(API_VERSION)/category/offer/family?customerId="
let URL_CATEGORIES_DEMAND_FAMILYC_COUNT = "\(URL_CATEGORIES)/demand/family"
let URL_CATEGORIES_WHOLESALER_FAMILY_COUNT = "\(URL_CATEGORIES)/wholesaler-list/family"
let URL_DEMANDS_SHARE = "\(URL_DEMAND)/share"
let URL_CUSTOMER_DEMAND = "\(URL_CUSTOMER)/demandsWithOffers/"
let URL_CUSTOMER_BUSINESS_REQUEST = "\(URL_CUSTOMER)/requestProduct"
let URL_FREE_DEMAND = "\(BASE_URL)/api/\(API_VERSION)/freedemand"
let URL_MAKE_ORDER = "\(BASE_URL)/api/\(API_VERSION)/order"
let URL_SEND_INVITATION = "\(URL_MAKE_ORDER)/invite"
let URL_GET_CUSTOMER_BUSINESS_NOTIFICATION = "\(BASE_URL)/api/\(API_VERSION)/businessvisit/customer"
let URL_GET_WHOLESALER_BUSINESS_NOTIFICATION = "\(BASE_URL)/api/\(API_VERSION)/businessvisit/wholesaler"
let URL_SEND_PRAPOSAL = "\(BASE_URL)/api/\(API_VERSION)/businessvisit"
let URL_ACCEPT_PRAPOSAL = "\(BASE_URL)/api/\(API_VERSION)/businessvisit/accept"
let URL_REJECT_PRAPOSAL = "\(BASE_URL)/api/\(API_VERSION)/businessvisit/reject"
let URL_SET_TIMESLOT = URL_SEND_PRAPOSAL
let URL_Add_AVAILIBILITY = URL_CUSTOMER
let URL_CONTACT_DISTRIBUTOR = "\(URL_OFFER)/contact"



// typealias  CompletionHandler = (_ Success: Bool) -> ()
typealias  CompletionHandler = (_ result: Any?) -> ()

// Segues
let INITIAL = "InitialNavigationController"
let INITIAL_WHOLESALER = "InitialWholeSalerNavigationController"
let FORGOT_NAVIGATION = "ForgotPasswordNav"
let RESET_PASSWORD_SCREEN = "ResetViewController"
let CUSTOMER_LOGIN = "LoginCustomer"
let WHOLESALER_LOGIN = "LoginWholeSaler"
let CUSTOMER_CREATE = "CreateAccountCustomer"
let WHOLESALER_CREATE = "WholeSalerAccountCustomer"
let WHOLESALER_CREATE_LIST_SEGUE = "WholeSalerCreatListSegue"
let WHOLESALER_OFFER_SEGUE = "WholesalerOfferSegue"
let CUSTOMER_BUSSINESS_REQUEST_SEGUE = "CustomerBussinessRequestSegue"
let THANKS_BUSINESS_REQUEST_SEGUE = "ThanksBusinessRequest"
let MAKE_AN_ORDER_SEGUE = "MakeAnOrderSegue"
let MAKE_ORDER_FINAL_STEP_SEGUE = "MakeOrderFinalStepSegue"
let SEND_DISTRIBUTOR_INVITE = "InviteDistributorSegue"
let WHOLESALER_BUSINESS_VISIT_SEGUE = "WholesalerBusinessVisitSegue"
let CUSTOMER_BUSINESS_VISIT_SEGUE = "CustomerBusinessVisitSegue"
let REVIEW_OFFERS_SEGUE = "ReviewOfferScreenSegue"
let REVIEW_OFFERS_DISTRIBUTOR_SEGUE = "DistributorListSegue"
let REVIEW_OFFERS_PRODUCT_SEGUE = "ProductListSegue"
let CONTACT_DISTRIBUTOR_THANK_YOU = "ContactDistributorThankYou"



let MAIN = "Main"
let MAIN_CUSTOMER = "MainCustomer"
let MENU_CUSTOMER = "MenuCustomer"
let MENU_WHOLESALER = "MenuWholeSaler"
let CUSTOMER_CONTACT_DATA = "CustomerContactData"
let WHOLESALER_CONTACT_DATA = "WholeSalerContactData"
let CUSTOMER_ADDRESS_DATA = "CustomerAddressData"
let WHOLESALER_ADDRESS_DATA = "WholeSalerAddressData"
let CUSTOMER_FAMILY_LIST = "CustomerFamilyList"
let CUSTOMER_FAMILY_SEGUE = "CustomerFamilySegue"
let CUSTOMER_FAMILY_ADD_SEGUE = "CustomerFamilyAddSegue"
let WHOLESALER_FAMILY_ADD_SEGUE = "WholeSalerFamilyAddSegue"
let CUSTOMER_ADD_FAMILY_SEGUE = "CustomerAddFamilySegue"
let CUSTOMER_SHOW_DEMANDS = "CustomerShowDemands"
let CUSTOMER_CREATE_FREE_LIST = "CustomerCreateFreeList"
let WHOLESALER_SHOW_LISTS = "WholeSalerShowLists"
let CUSTOMER_DEMAND_ADD = "CustomDemandAdd"
let WHOLESALER_LIST_ADD = "WholeSalerListAdd"
let CUSTOMER_SHOW_DEMANDS_FOR_SHARING = "CustomerShowDemandsForSharing"
let THANKS = "CustomerThanksViewControllerID"
let UPLOAD_DOWNLOAD_SEGUE = "UploadDownloadViewController"
let FREE_LIST_THANK_YOU = "FreeListThankYou"
let CUSTOMER_CREATE_LIST = "CustomerCreateList"
let CUSTOMER_REVIEW_LIST = "CustomerReviewList"

// User Defaults
let LOGGED_IN_KEY = "loggedIn"
let USER_ID = "userId"
let ID = "id"
let USER_EMAIL = "userEmail"
let CONTACT_EMAIL = "contactEmail"
let USER_PASSWORD = "password"
let USER_TYPE = "typeUser"
let CIF_OR_NIF = "cifOrNif"
let BUSINNES_NAME = "businnesName"
let BUSINNES_ID = "businnesId"
let CONTACT_NAME = "contacName"
let TELEPHONE = "telephone"
let ADDRESS = "adress"
let CITY = "city"
let POSTAL_CODE = "postalCode"
let PROVINCE = "province"
let COUNTRY = "country"
let NAME = "name"
// Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

// Messajes
let WARNING = "ATENCIÓN!"
let ERROR = "ERROR!"
let SUCCESS = "ÉXITO"
let PHONE_MISSING = "Por favor indique un valor para el teléfono"
let NAME_MISSING = "Por favor indique un valor para el nombre"
let ADDRESS_MISSING = "Por favor indique un valor para la dirección"
let CITY_MISSING = "Por favor indique un valor para para la ciudad"
let ZIP_CODE_MISSING = "Por favor indique un valor para el código postal"
let COUNTRY_MISSING = "Por favor indique un valor para el país"
let PROVINCE_MISSING = "Por favor indique un valor para la provincia"
let EMAIL_MISSING = "Por favor indique un valor para el email"
let PASSWORD_MISSING = "Por favor indique un valor para la clave"
let RE_PASSWORD_MISSING = "Por favor repita el valor para la clave"
let SECURY_PASSCODE_MISSING = "Por favor, introduzca un valor para el código de acceso de seguridad"
let PASSWORDS_ARE_NOT_EQUAL = "Las claves no coinciden"
let VAT_MISSING = "Por favor indique un valor para el CIF/NIF"
let TYPE_OF_BUSINESS_MISSING = "Por favor indique un valor para el tipo de establecimiento"
let LOGIN_FAILED = "Datos de acceso incorrectos. Por favor, corríjalos y vuelva a intentarlo"
let CUSTOMER_CREATE_FAILED = "Se produjo un error al crear la cuenta. Por favor, vuelva a intentarlo"
let WHOLESALER_CREATE_FAILED = "Se produjo un error al crear la cuenta. Por favor, vuelva a intentarlo"
let NO_DATA_FOUND = "No se pudo recuperar los datos"
let CONTACT_DATA_ERROR = "Por favor, añada información de contacto"
let ADDRESS_DATA_ERROR = "Por favor, añada información de dirección"
let EMAIL_DUPLICATED = "El email indicado ya está en uso"
let VAT_DUPLICATED = "El CIF/NIF indicado ya está en uso"
let CUSTOMER_CREATED_SUCCESS = "Restaurador creado con éxito"
let BRAND_MISSING = "Por favor indique un valor para marca"
let TYPE_OF_FORMAT_MISSING = "Por favor indique un valor para el tipo de formato"
let TARGET_PRICE_MISSING = "Por favor indique un valor para el precio objetivo"
let FORMAT_MISSING = "Por favor indique un valor para el formato"
let QUANTITY_OF_MONTH_MISSING = "Por favor indique un valor para el consumo mes"
let CUSTOMER_CREATE_DEMAND_FAILED = "Se produjo un error al crear la lista. Por favor, vuelva a intentarlo"
let OFFER_CREATE_DEMAND_FAILED = "Se produjo un error al crear la offerta. Por favor, vuelva a intentarlo"
let ZERO_ITEMS_SELECTED = "por favor, seleccione producto"
let ZERO_ITEMS_TO_OFFER = "No hay listas para realizar oferta"
let UPDATE_CUSTOMER_OK = "Restaurador actualizado correctamente"
let UPDATE_WHOLE_SALER_OK = "Distribuidor actualizado correctamente"
let MISSING_FREE_LIST_ERROR = "por favor, introduzca productos primero."
let MISSING_PROPER_PRODUCT_DETAIL = "Por favor ingrese el producto con la cantidad."
let MISSING_PRODUCT_DESCRIPTION = "Por favor ingrese la descripción del producto."
let MISSING_DELIVERY_DATE = "por favor ingrese la fecha de entrega."
let FAILURE_TO_CREATE_ORDER = "Hubo un error al crear la orden. Inténtalo de nuevo"
let SUCCESS_TO_CREATE_ORDER = "Tu pedido se ha enviado"
let FAILURE_TO_SEND_INVITATION = "Hubo un error al enviar una invitación. Inténtalo de nuevo"
let FAILURE_TO_SEND_PRAPOSAL = "Hubo un error al enviar una propuesta. Inténtalo de nuevo"
let MISSING_RESTAURANT_TYPE = "Seleccione el tipo de restaurante"
let MISSING_COMMENTS = "Por favor, indique un valor para el comentario"
let FAILURE_TO_SUBMIT = "Hubo un error para enviar. Inténtalo de nuevo"
let AVAILIBILITY_ADDED_SUCESSFULLY = "Agregar disponibilidad con éxito."
let FAILURE_TO_CONTACT = "Hubo un error al contactar al distribuidor."
let NO_INTERNET = "No se ha podido establecer conexión. Por favor, intentelo de nuevo"
let PRAPOSAL_SENT_SUCCESSFULLY = "propuesta enviada correctamente."















