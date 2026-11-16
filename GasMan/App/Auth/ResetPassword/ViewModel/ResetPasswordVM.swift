//
//  ResetPasswordVM.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation
import Combine

final class ResetPasswordVM : BaseViewModel  {
    @Published var resetPassword: BaseResponse<String>?
    @Published var validation: Error?
    
    var phone : String
    var code : String
    
    init(phone : String , code : String ) {
        self.phone = phone
        self.code = code
    }
    
    func resetPassword(model: ResetPasswordModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.resetPassword(model: model))
                isLoading = false
                resetPassword = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateUserData( password : String? , confirmPassword : String?){
        do {
            let password = try ValidationService.validate(password: password)
            let confirmPassword = try ValidationService.validate(newPassword: password, confirmPassword: confirmPassword)
            let model = ResetPasswordModel(phone: phone, password: password, passwordConfirmation: confirmPassword, code: code)
            resetPassword(model: model)
            
        }catch{
            validation = error
        }
    }
}

