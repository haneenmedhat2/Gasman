//
//  OrdersVM.swift
//  Esterad
//
//  Created by Haneen on 01/03/2026.
//

import Foundation
import Combine


final class OrdersVM: BaseViewModel {

    @Published var orders: BaseResponse<OrdersResponse>?

    var currentPage: Int = 1
    var isLastPage: Bool = false
    var ordersList: [Orders] = []
    var status: String = ""
    var orderStatusList: [OrderStatus] = []

    init(){
        super.init()
        self.refreshStatusList()
    }

    private func refreshStatusList() {
            status = OrderStatus.open.apiValue
            orderStatusList = [.open , .finished, .closed]
        }

    func getOrders() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    OrdersEndPoints.getOrders(path: status, page: currentPage))
            
                let newOrders = result.data?.data ?? []
                if currentPage == 1 {
                    ordersList.removeAll()
                    ordersList = newOrders
                } else {
                    ordersList.append(contentsOf: newOrders)
                }
                isLastPage = result.data?.pagination.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }
                orders = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func resetData() {
        currentPage = 1
        isLastPage = false
    }
}
