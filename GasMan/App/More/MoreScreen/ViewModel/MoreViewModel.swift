//
//  MoreViewModel.swift
//  Esterad
//
//  Created by Haneen on 29/10/2025.
//

import Foundation
import Combine

final class MoreVM: BaseViewModel {
    
    var signout: PassthroughSubject<BaseResponse<String>, Never> = .init()
    
    var menuItems: [MoreMenuItem] {
        return MoreMenuItem.moreItems(for: UserMode.current)
    }
    
    var moreList : [MoreMenuItem] = []

    func signoutRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.signout( deviceId:  UserDefaults.pushNotificationToken ?? "" ))
                signout.send(result)
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
