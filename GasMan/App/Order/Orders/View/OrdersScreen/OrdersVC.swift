//
//  OrdersVC.swift
//  Esterad
//
//  Created by Haneen on 01/03/2026.
//

import UIKit
import Combine

class OrdersVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var orderStateView: OrderStateView!
    @IBOutlet weak var tableView: TableViewContentSized!

    //MARK: - Properties -

    var viewModel: OrdersVM
    private let refreshControl = UIRefreshControl()

    //MARK: - Initializer -

    init(viewModel: OrdersVM ) {
        self.viewModel = viewModel
        super.init(nibName: "OrdersVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getOrders()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData),
                                               name: .isOrderChanged, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .isOrderChanged, object: nil)
    }

    //MARK: - Initial Setup -

    func initialConfiguration() {
        bindViewModel()
        configureTableView()
        setupNotificationButton()
        setupLeftBarButton()
        configureOrderStateView()
        setupRefreshControl()
    }

    private func configureOrderStateView() {
        orderStateView.delegate = self
        orderStateView.getCollectionViewDataSource(collectionArray: viewModel.orderStatusList)
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }


    //MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$orders
            .sinkOnMain { [weak self] _ in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    //MARK: - Actions -

    @objc private func refreshData() {
        viewModel.resetData()
        viewModel.getOrders()
    }
}

//MARK: - TableView Configurations -

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: OrderCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.ordersList.isEmpty, separator: .none, style: .emptyOrder)
        return viewModel.ordersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: OrderCell.self, for: indexPath)
        cell.setupCell(model: viewModel.ordersList[indexPath.row])
        cell.configureStatusBadge(for: OrderStatus(apiValue: viewModel.status))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.ordersList[indexPath.row]
        let vc = OrderDetailsVC(viewModel: OrderDetailsVM(orderId: item.id ?? 0))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.ordersList.count - 1, !viewModel.isLastPage {
            viewModel.getOrders()
        }
    }
}

//MARK: - StateView Delegation -

extension OrdersVC: OrderStateViewDelegate {
    func didSelectItem(at orderStatus: OrderStatus) {
        viewModel.status = orderStatus.apiValue
        viewModel.resetData()
        viewModel.getOrders()
    }
}

//MARK: - Routes -

extension OrdersVC {
    func goToNotification() {
        let vc = NotificationVC(viewModel: NotificationVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
