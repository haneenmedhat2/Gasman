//
//  ProductDetailsVC.swift
//  GasMan
//
//  Created by Haneen on 20/02/2026.
//

import UIKit
import Combine
import Kingfisher

class ProductDetailsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productStateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartView: IconTextGeneralButton!
    
    //MARK: - Properties -
    
    let viewModel : ProductDetailsVM
    
    //MARK: - Initializer -
    
    init(viewModel : ProductDetailsVM){
        self.viewModel = viewModel
        super.init(nibName: "ProductDetailsVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        bindViewModel()
        viewModel.getProductDetails()
        addToCartView.onTap = { [weak self ] in
            guard let self = self else { return }
            self.viewModel.addToCart()
        }
    }
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$productDetails
            .sinkOnMain { [weak self] productDetails in
                guard let productDetails = productDetails else { return }
                self?.configureUI(with: productDetails)
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(viewModel.$productDetails, viewModel.$quantity)
            .sinkOnMain { [weak self] productDetails, quantity in
                self?.quantityLabel.text = "\(quantity)"
                guard let unitPrice = productDetails?.price else { return }
                let cleaned = unitPrice.replacingOccurrences(of: ",", with: "")
                let total = (Double(cleaned) ?? 0) * Double(quantity)
                self?.priceLabel.text = "\(total)".toPrice
            }
            .store(in: &cancellables)
        
        viewModel.$addToCartSuccess
            .sinkOnMain { [weak self] success in
                guard let self = self, success else { return }
                self.showAddToCartPopup()
                self.viewModel.addToCartSuccess = false
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    private func configureUI(with product: ProductDetailsResponse) {
        self.title = product.category?.name
        productTypeLabel.text = product.fullTitle
        productStateLabel.text = product.type?.detailsText

        if let image = product.image {
            productImage.kf.setImage(with: URL(string: image))
        }
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapRemove(_ sender: UIButton) {
        viewModel.decreaseQuantity()
    }
    
    @IBAction func didTapAdd(_ sender: UIButton) {
        viewModel.increaseQuantity()
    }
}

//MARK: - Routes -

extension ProductDetailsVC {
    func showAddToCartPopup(){
        let popup = AddToCartPopup()
        popup.delegate = self
        popup.appear(sender: self)
    }
    
    func goToCart(){
        let tabBar = AppTabBarController()
        tabBar.selectedIndex = 1
        AppHelper.changeWindowRoot(vc: tabBar)
    }
}

//MARK: - Delegation -

extension ProductDetailsVC : AddToCartPopupProtocol{
    func didTapOnGoToCart() {
        goToCart()
    }
    
    func didTapOnContinueShopping(){
        NotificationCenter.default.post(name: .isCartChanged, object: nil)
        pop()
    }
}
