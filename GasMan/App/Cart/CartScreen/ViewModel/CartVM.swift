//
//  CartVM.swift
//  GasMan
//
//  Created by Haneen on 25/02/2026.
//

import Foundation
import Combine

final class CartVM: BaseViewModel {
    
    @Published private(set) var cart: CartResponse?
    @Published var updateCartSuccess: BaseResponse<String>?
    @Published var deleteCartSuccess: BaseResponse<String>?
    @Published var neighborhoods : [AreaModel] = []
    @Published var validation: Error?
    @Published var orderValidated = false
 
      var cartItems: [CartItem] {
          return cart?.items ?? []
      }
    
    var selectedNeighborhood : SelectionModelPicker?
    var model : CreateOrderModel = CreateOrderModel()


      // MARK: - Cart Actions -

    func increaseQty(at index: Int) {
        guard let item = cart?.items?[index],
              let productId = item.productId else { return }

        let newQty = (item.qty ?? 0) + 1
        updateCart(productId: productId, quantity: newQty)
    }

    func decreaseQty(at index: Int) {
        guard let item = cart?.items?[index],
              let productId = item.productId else { return }

        let current = item.qty ?? 0
        guard current > 1 else { return }

        updateCart(productId: productId, quantity: current - 1)
    }

    func removeItem(at index: Int) {
        guard let item = cart?.items?[index],
              let cartId = item.cartId else { return }

        deleteCart(cartId: cartId)
    }


    func getCartData() {
        isLoading = true
        Task {
            do {
                let result  = try await getAllRequest(CartEndPoints.showCartData())
                cart = result.data?.first

                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func updateCart(productId: Int, quantity: Int) {
        isLoading = true

        Task {
            do {
                let result = try await getAllRequest( CartEndPoints.addToCart(
                        productId: productId,
                        quantity: quantity
                    )
                )

                updateCartSuccess = result
                getCartData()

            } catch {
                self.error = error
            }

            isLoading = false
        }
    }
    
    func deleteCart(cartId: Int) {
        isLoading = true

        Task {
            do {
                let result = try await getAllRequest(
                    CartEndPoints.deleteCart(cartId: cartId)
                )

                deleteCartSuccess = result
                getCartData()

            } catch {
                self.error = error
            }

            isLoading = false
        }
    }
    
    func getNeighborhoods() {
        isLoading = true

        Task {
            do {
                let result = try await getAllRequest(CartEndPoints.getNeighborhoods(cityId: Session.user?.city?.id ?? 0))

                neighborhoods = result.data ?? []

            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
    
    func validateData(address: String?) {
        do {
            _ = try ValidationService.validate(emptyLocation: address)
            _ = try ValidationService.validate(areaId: model.neighborhoodId)
            _ = try ValidationService.validate(phone: model.userPhone)

            orderValidated = true

        } catch {
            validation = error
            orderValidated = false
        }
    }
}
