//
//  ForgetPasswordVM.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation
import Combine

final class ForgetPasswordVM: BaseViewModel {
    
    @Published var forgetPassword: BaseResponse<String>?
    @Published var validationError: Error?
    
    func forgetPassword(phone: String) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.forgetPassword(phone: phone))
                isLoading = false
                forgetPassword = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validatePhone(phone: String?) {
        
        do {
            let phoneNum = try ValidationService.validate(phone: phone)
            forgetPassword(phone: phoneNum)
            
        }catch{
            validationError = error
        }
    }
}
