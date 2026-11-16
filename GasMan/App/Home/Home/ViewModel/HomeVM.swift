//
//  HomeVM.swift
//  Esterad
//
//  Created by Haneen on 11/11/2025.
//

import Foundation
import Combine

final class HomeVM: BaseViewModel {
 
    @Published var home: BaseResponse<HomeResponse>?
    
    var categoryList : [Categories] = []
    var sliderList : [Slider] = []

    func gethomeData(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(HomeEndPoints.getHomeData())
                categoryList = result.data?.categoriesWithProducts ?? []
                sliderList = result.data?.sliders ?? []
                home = result

                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
