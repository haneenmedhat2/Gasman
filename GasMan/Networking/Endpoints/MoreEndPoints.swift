//
//  MoreEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 21/08/2025.
//

import Foundation
import Alamofire


struct MoreEndpoints {
    private init() {}
}

extension MoreEndpoints {
  
    //MARK: - Profile -
    static func profile() -> Endpoint<BaseResponse<User>>{
        return .init(
            method: .get,
            path: "profile",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func updateProfile(model: UpdateProfileModel, uploads: [UploadData]) -> Endpoint<BaseResponse<User>> {
        return .init(
            method: .post, 
            path: "update-profile",
        
            body: [
                "_method": "PUT",
                "name": model.name,
                "city_id": model.cityId,
                "email": model.email
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: uploads
        )
    }
    
    //MARK: - Settings -

    static func sendCurrentPhoneCode() -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "change-phone-old-phone-send-code",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func changeOldPhoneCheckCode(code : String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "change-phone-old-phone-check-code",
            body : [
                "code" : code
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func resendPhoneCode(type : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "change-phone-re-send-code",
            body: [
                "type" : type
            ],
            headerType: .authorized(token: Session.token ?? ""),
        )
    }
    
    static func sendCodeNewPhone(phone : String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "change-phone-new-phone-send-code",
            body: [
                "country_code" : "966",
                "phone" : phone
            ],
            headerType: .authorized(token: Session.token ?? ""),
        )
    }

    static func newPhoneCheckCode(code : String , phone : String) -> Endpoint<BaseResponse<User>>{
        return .init(
            method: .post,
            path: "change-phone-new-phone-check-code",
            body: [
                "country_code" : "966",
                "phone" : phone,
                "code" : code
            ],
            headerType: .authorized(token: Session.token ?? ""),
        )
    }
    
    static func changePassword(model:ChangePasswordModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .patch,
            path: "update-password",
            body: [
                "old_password": model.currentPassword,
                "password" : model.password,
                "password_confirmation" : model.passwordConfirmation
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func switchNotification() -> Endpoint<BaseResponse<SwitchNotification>>{
        return .init(
            method: .patch,
            path: "switch-notify",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func changeLanguage(lang: String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .patch,
            path: "change-lang?lang=\(lang)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteAccount(deviceId: String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delete-account",
            body: [
                "device_id": deviceId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    //MARK: - Wallet -

    static func showWallet() -> Endpoint<BaseResponse<WalletResponse>>{
        return .init(
            method: .get,
            path: "show-wallet",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func chargeWallet( amount: Double) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "charge-wallet",
            body: ["amount" : amount],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func withdrawMoney(model: WithdrawMoney) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "send-withdraw-request",
            body: [
                "amount" : model.amount,
                "bank_name" : model.bankName,
                "bank_account_number" : model.bankAccountNumber,
                "iban" : model.iban,
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    //MARK: - Static Pages -

    static func aboutUs() -> Endpoint<BaseResponse<StaticPagesModel>>{
        return .init(
            method: .get,
            path: "about"
        )
    }
    
    static func termsAndConditions() -> Endpoint<BaseResponse<StaticPagesModel>>{
        return .init(
            method: .get,
            path: "terms"
        )
    }
    
    static func privacyPolicy() -> Endpoint<BaseResponse<StaticPagesModel>>{
        return .init(
            method: .get,
            path: "privacy"
        )
    }
    
    static func getFaq() -> Endpoint<BaseResponse<[FAQModel]>>{
        return .init(
            method: .get,
            path: "get-fqss"
        )
    }
    
    static func sendComplaints(model : ComplaintsModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "store-complaint",
            body: [
                "subject" : model.subject,
                "complaint" : model.complaint,
                "type" : model.type
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: model.uploadData

        )
    }
    

    static func contactUs(model: ContactUsModel) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "send-contact-message",
            body: [
                "user_name " : model.name,
                "email" : model.email,
                "subject" : model.subject
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: model.uploadData
        )
    }
    
    static func contactUsData() -> Endpoint<BaseResponse<ContactUsDataResponse>> {
        return .init(
            method: .get,
            path: "contact-us-data"
        )
    }
    
    static func getReviews() -> Endpoint<BaseResponse<ReviewsResponse>>{
        return .init(
            method: .get,
            path: "my-ratings",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func signout(deviceId: String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .delete,
            path: "sign-out",
            body: [
                "device_id": deviceId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    //MARK: - Saved Addresses -
    
    static func savedAddresses(page: Int) -> Endpoint<BaseResponse<SavedAddressesResponse>>{
        return .init(
            method: .get,
            path: "locations",
            queries : [
                "page": page
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func storeAddress(model: ManageAddress) -> Endpoint<BaseResponse<SavedAddresses>>{
        return .init(
            method: .post,
            path: "store-location",
            body : [
                "name": model.name,
                "map_desc" : model.mapDesc,
                "lat" : model.lat,
                "lng" : model.lng,
                "city_id" : model.cityId,
                "building_number" : model.buildingNumber,
                "street_name" : model.streetName
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
   
    static func updateAddress(model: ManageAddress) -> Endpoint<BaseResponse<SavedAddresses>>{
        return .init(
            method: .post,
            path: "update-location",
            body : [
                "name": model.name,
                "map_desc" : model.mapDesc,
                "lat" : model.lat,
                "lng" : model.lng,
                "city_id" : model.cityId,
                "building_number" : model.buildingNumber,
                "street_name" : model.streetName,
                "location_id" : model.locationId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteAddres(id: Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .delete,
            path: "delete-location/\(id)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
