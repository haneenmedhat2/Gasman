//
//  AuthEndpoints.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation
import Alamofire

struct AuthEndpoints {
    private init() {}
}

extension AuthEndpoints {
    
    static func login(model : LoginModel) -> Endpoint<BaseResponse<User>>{
        return .init(
            method: .post,
            path: "sign-in",
            body: [
                "phone": model.phone,
                "password": model.password,
                "mac_address" : nil,
                "device_id": UserDefaults.pushNotificationToken ?? "",
                "device_type": "ios",
                "country_code" : "966"
            ]
        )
    }
    
    static func signup(model: SignupModel, uploads: [UploadData]) -> Endpoint<BaseResponse<User>>{
        return .init(
            method: .post,
            path: "sign-up",
            body:[
                "name" : model.name,
                "phone" : model.phone,
                "email" : model.email,
                "country_code" : "966",
                "city_id" : model.cityId,
                "password" : model.password,
                "password_confirmation" : model.confirmPassword,
                "lang": Language.apiLanguage()
            ],
            uploads: uploads
        )
    }
    
    static func getCities() -> Endpoint<BaseResponse<[AreaModel]>>{
        return .init(
            method: .get,
            path: "cities"
        )
    }
    
    static func verification(model : VerificationModel) -> Endpoint<BaseResponse<User>> {
        return .init(
            method: .patch,
            path: "activate",
            body: [
                "code": model.code,
                "country_code" : model.countryCode,
                "phone" : model.phone,
                "device_id" : model.deviceId,
                "device_type" : model.deviceType
            ]
        )
    }
    
    static func resendCode(phone : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .patch,
            path: "resend-code",
            body: [
                "country_code" : "966",
                "phone" : phone
            ]
        )
    }
    
    static func forgetPassword(phone: String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "forget-password-send-code",
            body: [
                "phone": phone,
                "country_code": "966"
            ]
        )
    }
    
    static func forgetPasswordCheckCode(phone: String , code : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "forget-password-check-code",
            body: [
                "phone": phone,
                "country_code": "966",
                "code" : code
            ]
        )
    }
    
    static func forgetPasswordResendCode(phone : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "forget-password-resend-code",
            body: [
                "country_code" : "966",
                "phone" : phone
            ]
        )
    }
    
    static func resetPassword(model : ResetPasswordModel) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "reset-password",
            body: [
                "country_code" : "966",
                "phone" : model.phone,
                "code" : model.code,
                "password" : model.password,
                "password_confirmation" : model.passwordConfirmation
            ]
        )
    }
}
