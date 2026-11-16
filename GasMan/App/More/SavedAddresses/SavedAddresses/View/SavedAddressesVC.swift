//
//  SavedAddressesVC.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//

import UIKit
import Combine

class SavedAddressesVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    var viewModel : SavedAddressesVM
    
    //MARK: - Initializer -
    
    init(viewModel : SavedAddressesVM){
        self.viewModel = viewModel
        super.init(nibName: "SavedAddressesVC", bundle: nil)
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
    
    func initialConfiguration() {
        self.title = "saved_addresses".localized
        bindViewModel()
        configureTableView()
        viewModel.getSavedAddresses()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$savedAddresses
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$deleteAddress
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapAddNewAddress(_ sender: UIButton) {
        goToManageAddress(mode: .addNewAddress , model : nil)
    }
}

//MARK: - TableView Configurations  -

extension SavedAddressesVC : UITableViewDelegate , UITableViewDataSource {
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: SavedAddressesCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.savedAddressesList.isEmpty , separator: .none, style: .savedAddresses)
        return viewModel.savedAddressesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SavedAddressesCell.self, for: indexPath)
        cell.delegate = self
        let item = viewModel.savedAddressesList[indexPath.row]
        if item.isSelected {
            viewModel.selectedIndex = indexPath
        }
        cell.setupCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = viewModel.selectedIndex {
            viewModel.savedAddressesList[selectedIndex.row].isSelected = false
        }
        viewModel.savedAddressesList[indexPath.row].isSelected = true
        viewModel.selectedIndex = indexPath
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.savedAddressesList.count - 1,
           !viewModel.isLastPage {
            viewModel.getSavedAddresses()
        }
    }
}

//MARK: - Delegation -

extension SavedAddressesVC : ManageAddressVCDelegate {
    func manageAddressDidSave() {
        viewModel.resetData()
        viewModel.getSavedAddresses()
    }
}

extension SavedAddressesVC : SavedAddressesCellProtocol , DoubleActionPopupProtocol {
    
    func didTapUpdateBtn(model: SavedAddresses) {
        goToManageAddress(mode: .updateAddress , model : model)
    }
    
    func didTapDeleteBtn(id: Int) {
        viewModel.addressId = id
        showDoubleActionPopup()
    }

    func didTapSecondAction() {
        viewModel.deleteAddressRequest()
    }
}

//MARK: - Routes -

extension SavedAddressesVC {
    
    func goToManageAddress(mode: ManageAddressMode , model : SavedAddresses?){
        let vc = ManageAddressVC(viewModel: ManageAddressVM(mode: mode, model: model))
        vc.delegate = self
        push(vc)
    }
    
    func showDoubleActionPopup(){
        let vc = DoubleActionPopupView()
        vc.delegate = self
        vc.appear(sender: self)
        vc.setupView(type: .deleteAddress)
    }
}
