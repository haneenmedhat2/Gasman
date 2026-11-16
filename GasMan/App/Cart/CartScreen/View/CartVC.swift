//
//  CartVC.swift
//  GasMan
//
//  Created by Haneen on 04/02/2026.
//

import UIKit
import Combine

class CartVC: BaseViewController {
    
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var phoneTextField: GeneralTextField!
    @IBOutlet weak var locationTextField: GeneralTextField!
    @IBOutlet weak var districtTextField: PickerFieldView!
    @IBOutlet weak var notesTextField: GeneralTextField!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var emptyStateView: UIView!
    
    //MARK: - Properties -
    
    let viewModel : CartVM
    
    //MARK: - Initializer -
    
    init(viewModel : CartVM){
        self.viewModel = viewModel
        super.init(nibName: "CartVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver( self, selector: #selector(refreshData),
                                                name: .isCartChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .isCartChanged, object: nil)
    }
    
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        setupNotificationButton()
        setupLeftBarButton()
        bindViewModel()
        configureTableView()
        viewModel.getCartData()
        setupUI()
    }
    
    func setupUI(){
        Language.isRTL() ? backButton.setImage(UIImage(resource: .backBtn), for: .normal) : backButton.setImage(UIImage(resource: .backBtnAr), for: .normal)
        
        locationTextField.txtField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLocationTapped))
        locationTextField.addGestureRecognizer(tap)
        
        districtTextField.delegate = self
        
        phoneTextField.optionalBtn.setUnderlinedTitle( "change_mobile_number".localized)
        phoneTextField.txtField.isEnabled = false
        phoneTextField.txtField.text = Session.user?.phone
        phoneTextField.onOptionalBtnTapped = { [weak self]  in
            guard let self = self else { return }
            phoneTextField.txtField.isEnabled = true
        }
    }
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$cart
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.updateEmptyState()
            }
            .store(in: &cancellables)
        
        viewModel.$updateCartSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                show(successMessage: result.message)
            }
            .store(in: &cancellables)

        viewModel.$deleteCartSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                show(successMessage: result.message)

            }
            .store(in: &cancellables)
        
        viewModel.$neighborhoods
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                self.showPickerPopup()
            }
            .store(in: &cancellables)
        
        viewModel.$validation
            .compactMap { $0 }
            .sinkOnMain { [weak self] error in
                guard let self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        viewModel.$orderValidated
            .filter { $0 }
            .sinkOnMain { [weak self] _ in
                self?.goToCartInquiry()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Empty State -

    private func updateEmptyState() {
        let isEmpty = viewModel.cartItems.isEmpty
        contentStack.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
    }

    //MARK: - PickerPopup  -
    
    func showPickerPopup() {
        let popup = PickerListPopup()
        popup.allowMultipleSelection = false
        popup.pickerList = viewModel.neighborhoods
        popup.selectedItem = viewModel.selectedNeighborhood
        popup.onItemSelected = { [weak self] item in
            guard let self else { return }
            self.viewModel.selectedNeighborhood = item
            self.viewModel.model.neighborhoodId = item?.pickerId
            self.districtTextField.txtField.text = item?.pickerName
        }
        popup.appear(sender: self)
    }
    
    
    //MARK: - Action -
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        goToHome()
    }
    
    @IBAction func didTapSavedLocation(_ sender: UIButton) {
        goToSelectAddress()
    }
    
    @IBAction func didTapCompleteOrder(_ sender: UIButton) {
        viewModel.model.notes = notesTextField.txtField.text
        viewModel.model.userPhone = phoneTextField.txtField.text
        viewModel.validateData(address : locationTextField.txtField.text)
    }
    
    @objc func onLocationTapped(){
        goToSelectLocation()
    }
    
    @objc func refreshData(){
        viewModel.getCartData()
    }
}

//MARK: - TableView Configurations -

extension CartVC : UITableViewDataSource, UITableViewDelegate {
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ProductCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell( with: ProductCell.self,for: indexPath)
        
        let item = viewModel.cartItems[indexPath.row]
        cell.setupCell(model: item)
        cell.delegate = self
        
        return cell
    }
}

//MARK: - Cell Delegation -

extension CartVC: ProductCellDelegate, PickerFieldViewDelegate {
    
    func didTapDelete(cell: ProductCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.removeItem(at: indexPath.row)
    }
    
    func didTapAdd(cell: ProductCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.increaseQty(at: indexPath.row)
    }
    
    func didTapRemove(cell: ProductCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.decreaseQty(at: indexPath.row)
    }
    
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        if viewModel.neighborhoods.isEmpty {
            viewModel.getNeighborhoods()
        } else {
            showPickerPopup()
        }
    }
}

//MARK: - Routes -

extension CartVC {
    func goToSelectLocation(){
        let vc = SelectLocationVC(viewModel: SelectLocationVM())
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.onLocationSelected = { [weak self ] address in
            guard let self = self else { return }
            self.locationTextField.txtField.text = address.desc
            self.viewModel.model.lat = address.lat
            self.viewModel.model.lng = address.long
            self.viewModel.model.mapDesc = address.desc
            self.viewModel.model.locationId = nil
           }
        push(vc)
    }
    
    func goToSelectAddress(){
        let vc = SelectAddressVC(viewModel: SelectAddressVM())
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.onAddressSelected = { [weak self ] address in
            guard let self = self else { return }
            self.locationTextField.txtField.text = address.mapDesc
            self.viewModel.model.locationId = address.id
            self.viewModel.model.lat = nil
            self.viewModel.model.lng = nil
            self.viewModel.model.mapDesc = nil
        }
        push(vc)
    }
    
    func goToHome(){
        let tabBar = AppTabBarController()
        tabBar.selectedIndex = 0
        AppHelper.changeWindowRoot(vc: tabBar)
    }
    
    func goToCartInquiry() {
        let vc = CartInquiryVC(viewModel: CartInquiryVM(model: viewModel.model))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
    
