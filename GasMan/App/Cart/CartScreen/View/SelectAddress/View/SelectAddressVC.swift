//
//  SelectAddressVC.swift
//  GasMan
//
//  Created by Haneen on 25/02/2026.
//

import UIKit
import Combine

class SelectAddressVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var confirmButton: MainButton!
    
    //MARK: - Properties -
    
    var viewModel : SelectAddressVM
    
    //MARK: - Initializer -
    
    init(viewModel : SelectAddressVM){
        self.viewModel = viewModel
        super.init(nibName: "SelectAddressVC", bundle: nil)
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
        
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.5
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.savedAddressesPublisher
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapConfirmAddress(_ sender: UIButton) {
        guard let selectedAddress = viewModel.getSelectedAddress() else { return }

        viewModel.onAddressSelected?(selectedAddress)
        pop()
    }
}

//MARK: - TableView Configurations  -

extension SelectAddressVC : UITableViewDelegate , UITableViewDataSource {
    
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
        
        let item = viewModel.savedAddressesList[indexPath.row]
        if item.isSelected {
            viewModel.selectedIndex = indexPath
        }
        cell.setupCell(model: item)
        cell.deleteButton.isHidden = true
        cell.updateButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedIndex = viewModel.selectedIndex {
            viewModel.savedAddressesList[selectedIndex.row].isSelected = false
        }

        viewModel.savedAddressesList[indexPath.row].isSelected = true
        viewModel.selectedIndex = indexPath

        confirmButton.isEnabled = true
        confirmButton.alpha = 1

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.savedAddressesList.count - 1,
           !viewModel.isLastPage {
            viewModel.getSavedAddresses()
        }
    }
}
