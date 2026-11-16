//
//  LoginVM.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import Foundation
import Combine

final class LoginVM: BaseViewModel {
    
    @Published var login: BaseResponse<User>?
    @Published var validationError: Error?
    
    func loginRequest(model: LoginModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.login(model: model))
                Session.user = result.data
                Session.token = result.data?.token
                isLoading = false
                login = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateInputs(model: LoginModel) {
        
        do {
            _ = try ValidationService.validate(phone: model.phone)
            _ = try ValidationService.validate(password: model.password)
            loginRequest(model: model)
            
        }catch{
            validationError = error
        }
    }
}
