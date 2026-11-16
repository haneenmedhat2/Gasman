//
//  SavedAddressesVM.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//


import Foundation
import Combine
import UIKit

final class SavedAddressesVM: BaseViewModel {
    
    @Published var deleteAddress: BaseResponse<String>?
    @Published var savedAddresses: [SavedAddresses] = []
    
    var savedAddressesList: [SavedAddresses] = []
    var currentPage:Int = 1
    var isLastPage: Bool = false
    var selectedIndex: IndexPath? 
    var addressId : Int = 0

    func getSavedAddresses(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.savedAddresses(page: currentPage))
                
                let savedAddressesList = result.data?.data ?? []
                
                if currentPage == 1 {
                    self.savedAddressesList.removeAll()
                    self.savedAddressesList = savedAddressesList
                } else {
                    self.savedAddressesList.append(contentsOf: savedAddressesList)
                }
                
                isLastPage = result.data?.pagination?.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }
                
                savedAddresses = result.data?.data ?? []
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteAddressRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.deleteAddres(id: addressId))
            
                deleteAddress = result
                resetData()
                getSavedAddresses()
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func resetData(){
        currentPage = 1
        isLastPage = false
    }
}
    
