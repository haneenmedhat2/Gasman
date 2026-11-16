//
//  UpdateProfileVM.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import Foundation
import Combine


final class UpdateProfileVM: BaseViewModel {
    @Published var updateProfile: BaseResponse<User>?
    @Published var citiesList: [AreaModel] = []
    @Published var validation: Error?
    
    var image : Data?
    var selectedCity : SelectionModelPicker?

    func updateProfileRequest(model: UpdateProfileModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.updateProfile( model: model, uploads: model.uploadData))
                Session.user = result.data
                updateProfile = result
                isLoading = false
                
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
    
    func validateUserData(model: UpdateProfileModel)  {
        do {
            _ = try ValidationService.validate(name: model.name)
            
            if let email = model.email, !email.trimWhiteSpace().isEmpty {
                _ = try ValidationService.validate(email: email)
            }
            
            updateProfileRequest(model: model)
            
        }catch{
            validation = error
        }
    }
}
