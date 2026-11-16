//
//  ProductDetailsVM.swift
//  GasMan
//
//  Created by Haneen on 23/02/2026.
//


import Foundation
import Combine


final class ProductDetailsVM: BaseViewModel {
    
    @Published private(set) var productDetails: ProductDetailsResponse?
    @Published var addToCartSuccess: Bool = false
    @Published var quantity: Int = 1

    var productId : Int

    init(productId: Int) {
        self.productId = productId
    }
    
    func increaseQuantity() {
        quantity += 1
    }
    
    func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    func getProductDetails(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(HomeEndPoints.getProductDetails(id: productId))
                productDetails = result.data

                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func addToCart() {
        isLoading = true
        Task {
            do {
                let _ = try await getAllRequest(CartEndPoints.addToCart(productId: productId , quantity: quantity))
                addToCartSuccess = true

                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
