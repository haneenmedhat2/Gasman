//
//  CartInquiryVC.swift
//  GasMan
//
//  Created by Haneen on 26/02/2026.
//

import UIKit
import Combine

class CartInquiryVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var payNowButton: MainButton!
    @IBOutlet weak var orderSummaryView: OrderSummaryView!
    @IBOutlet weak var couponView: CouponView!

    //MARK: - Properties -

    let viewModel: CartInquiryVM

    //MARK: - Initializer -

    init(viewModel: CartInquiryVM) {
        self.viewModel = viewModel
        super.init(nibName: "CartInquiryVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    //MARK: - Initial Setup -

    func initialConfiguration() {
        setupNotificationButton()
        setupLeftBarButton()
        bindViewModel()
        configureTableView()
        configureCollectionView()
        setupCouponView()
        viewModel.getCartData()
        setupUI()
        updatePayNowButtonTitle()
    }

    func setupUI() {
        Language.isRTL()
            ? backButton.setImage(UIImage(resource: .backBtn), for: .normal)
            : backButton.setImage(UIImage(resource: .backBtnAr), for: .normal)
    }

    //MARK: - Coupon -

    private func setupCouponView() {
        couponView.onActivate = { [weak self] couponCode in
            guard let self = self else { return }
            if self.viewModel.model.couponNum == couponCode {
                self.showErrorToast(with: "coupon_already_applied".localized)
                return
            }
            self.viewModel.model.couponNum = couponCode
            self.viewModel.getCartInquiry()
        }

        couponView.onClear = { [weak self] in
            guard let self = self else { return }
            self.viewModel.model.couponNum = nil
            self.viewModel.getCartInquiry()
        }

        couponView.onEmptyCoupon = { [weak self] in
            self?.showErrorToast(with: "enter_coupon".localized)
        }
    }

    //MARK: - Button Title -

    private func updatePayNowButtonTitle() {
        let isElectronic = viewModel.indexPath.row == 0
        let title = isElectronic ? "pay_now".localized : "order_now".localized
        payNowButton.setTitle(title, for: .normal)
    }

    //MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$cart
            .sinkOnMain { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$cartInquiry
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.orderSummaryView.getDataSource(model: result, numOfProducts: viewModel.cart?.totalQty ?? 0)
            }
            .store(in: &cancellables)

        viewModel.$createOrder
            .compactMap { $0 }
            .sinkOnMain { [weak self] response in
                guard let self = self else { return }
                self.showPopup(response : response)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    //MARK: - Actions -

    @IBAction func didTapBackButton(_ sender: UIButton) {
        pop()
    }

    @IBAction func didTapPayNow(_ sender: UIButton) {
        // payType: 0 = electronic, 1 = cash on delivery
        viewModel.model.payType = viewModel.indexPath.row == 0 ? 0 : 1
        viewModel.createOrderRequest()
    }
}

//MARK: - TableView Configurations -

extension CartInquiryVC: UITableViewDataSource, UITableViewDelegate {

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ProductCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProductCell.self, for: indexPath)
        let item = viewModel.cartItems[indexPath.row]
        cell.setupCell(model: item, isOrderInquiry: true)
        return cell
    }
}

//MARK: - CollectionView Configuration -

extension CartInquiryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func configureCollectionView() {
        collectionView.register(cellType: SelectableOptionCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.paymentList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SelectableOptionCell.self, for: indexPath)
        let item = viewModel.paymentList[indexPath.row]
        cell.setupCell(model: item, isSelected: viewModel.indexPath == indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath != viewModel.indexPath else { return }
        viewModel.indexPath = indexPath
        collectionView.reloadData()
        updatePayNowButtonTitle()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 12) / 2, height: 40)
    }
}

//MARK: - Routes -

extension CartInquiryVC {
    func showPopup(response : BaseResponse<Int>){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: response.message)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            self.goToOrderDetails(orderId : response.data ?? 0)
        }
    }
    
    func goToOrderDetails(orderId : Int){
        let tabBar = AppTabBarController()
        tabBar.selectedIndex = 2
        AppHelper.changeWindowRoot(vc: tabBar)
        
        if let ordersNav = tabBar.viewControllers?[2] as? UINavigationController {
            let vc = OrderDetailsVC(viewModel: OrderDetailsVM(orderId: orderId))
            vc.hidesBottomBarWhenPushed = true
            ordersNav.pushViewController(vc, animated: true)
        }
    }
}
