//
//  ManageAddressVM.swift
//  GasMan
//
//  Created by Haneen on 17/02/2026.
//

import Foundation
import Combine
import UIKit

final class ManageAddressVM: BaseViewModel {
    
    @Published var citiesList: [AreaModel] = []
    @Published var validation: Error?
    @Published var storeAddress: BaseResponse<SavedAddresses>?

    var selectedCity : SelectionModelPicker?
    var mode : ManageAddressMode
    var model : SavedAddresses?

    init(mode : ManageAddressMode , model : SavedAddresses?){
        self.mode = mode
        self.model = model
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
    
    func addNewAddress(model : ManageAddress){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.storeAddress(model:model ))
                
                storeAddress = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func updateAddress(model : ManageAddress) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.updateAddress(model: model))
                storeAddress = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func validateData(model: ManageAddress)  {
        do {
            _ = try ValidationService.validate(addressName: model.name)
            _ = try ValidationService.validate(cityId: model.cityId)
            _ = try ValidationService.validate(streetName: model.streetName)
            _ = try ValidationService.validate(buildingNum : model.buildingNumber)
            
            switch mode {
            case .addNewAddress:
                addNewAddress(model: model)

            case .updateAddress:
                updateAddress(model: model)
            }
            
        }catch{
            validation = error
        }
    }
}
