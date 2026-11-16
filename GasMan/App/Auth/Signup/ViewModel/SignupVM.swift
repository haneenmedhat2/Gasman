//
//  SignupVM.swift
//  Esterad
//
//  Created by Haneen on 18/10/2025.
//

import Foundation
import Combine


final class SignupVM: BaseViewModel {
    
    @Published var signup: BaseResponse<User>?
    @Published var citiesList: [AreaModel] = []
    @Published var validation: Error?
    
    var isChecked : Bool = false
    var image : Data?
    var selectedCity : SelectionModelPicker?

    func register(model: SignupModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.signup(model: model, uploads: model.uploadData))
                isLoading = false
                signup = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getCities(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.getCities())
                isLoading = false
                citiesList = result.data ?? []
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateUserData(model: SignupModel)  {
        do {
            _ = try ValidationService.validate(name: model.name)
            
            if let email = model.email, !email.trimWhiteSpace().isEmpty {
                _ = try ValidationService.validate(email: email)
            }
            
            _ = try ValidationService.validate(phone: model.phone)
            _ = try ValidationService.validate(cityId: selectedCity?.pickerId)
            _ = try ValidationService.validate(password: model.password)
            _ = try ValidationService.validate(newPassword: model.password, confirmPassword: model.confirmPassword)
            _ = try ValidationService.validate(termesAgreed: isChecked )
            register(model: model)
            
        }catch{
            validation = error
        }
    }
}

