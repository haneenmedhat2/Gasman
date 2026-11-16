//
//  CartInquiryVM.swift
//  GasMan
//
//  Created by Haneen on 26/02/2026.
//

import Foundation
import Combine
import UIKit

final class CartInquiryVM: BaseViewModel {
    
    @Published private(set) var cart: CartResponse?
    @Published private(set) var cartInquiry: CartInquiryResponse?
    @Published private(set) var createOrder: BaseResponse<Int>?

    var indexPath : IndexPath  = IndexPath(row: 0, section: 0 )
    var paymentList : [SelectionOptionType] = [.electronic,.cashOnDelivery]

    var cartItems: [CartItem] {
        return cart?.items ?? []
    }
    
    var model : CreateOrderModel
    init(model : CreateOrderModel){
        self.model = model
    }
    
    func getCartData() {
        isLoading = true
        Task {
            do {
                let result  = try await getAllRequest(CartEndPoints.showCartData())
                cart = result.data?.first
                getCartInquiry()
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getCartInquiry() {
        isLoading = true
        Task {
            do {
                let result  = try await getAllRequest(CartEndPoints.getCartInquiry(model: model))
                cartInquiry = result.data
                
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func createOrderRequest() {
        isLoading = true
        Task {
            do {
                let result  = try await getAllRequest(CartEndPoints.createOrder(model: model))
                createOrder = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
