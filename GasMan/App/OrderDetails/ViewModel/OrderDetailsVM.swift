//
//  OrderDetailsVM.swift
//  GasMan
//
//  Created by Haneen on 02/03/2026.
//

import Foundation
import Combine

final class OrderDetailsVM: BaseViewModel {

    @Published private(set) var orderDetails: OrderDetails?
    @Published private(set) var cancelReasons: [CancelReasonModel] = []
    @Published private(set) var cancelSuccess: BaseResponse<String>?
    @Published private(set) var rateSuccess: BaseResponse<String>?
    private(set) var lastRateModel: RateOrderModel?

    let orderId: Int

    init(orderId: Int) {
        self.orderId = orderId
    }

    func getOrderDetails() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.getOrderDetails(orderId: orderId))
                orderDetails = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func getCancelReasons() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.getCancelReasons())
                cancelReasons = result.data ?? []
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func cancelOrder(reasonId: Int) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.cancelOrder(orderId: orderId, cancelReasonId: reasonId))
                cancelSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func rateOrder(model: RateOrderModel) {
        isLoading = true
        lastRateModel = model
        Task {
            do {
                let result = try await getAllRequest(OrderDetailsEndPoints.rateOrder(model: model))
                rateSuccess = result
                getOrderDetails()
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
