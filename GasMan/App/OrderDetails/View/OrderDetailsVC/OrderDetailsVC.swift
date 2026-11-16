//
//  OrderDetailsVC.swift
//  GasMan
//
//  Created by Haneen on 02/03/2026.
//

import UIKit
import Combine

class OrderDetailsVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusBarView: OrderStatusBarView!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var orderSummaryView: OrderSummaryView!
    @IBOutlet weak var driverInfoView: DriverInfoView!
    @IBOutlet weak var clientNotesView: LabeledNoteView!
    @IBOutlet weak var cancelReasonView: LabeledNoteView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var receivedButton: MainButton!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var invoiceButton: UIButton!
    
    //MARK: - Properties -

    let viewModel: OrderDetailsVM
    private let refreshControl = UIRefreshControl()

    //MARK: - Initializer -

    init(viewModel: OrderDetailsVM) {
        self.viewModel = viewModel
        super.init(nibName: "OrderDetailsVC", bundle: nil)
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData),
                                               name: .isOrderChanged, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .isOrderChanged, object: nil)
    }

    //MARK: - Setup -

    func initialConfiguration() {
        self.title = "track_order".localized
        view.isHidden = true
        configureTableView()
        setupRefreshControl()
        bindViewModel()
        viewModel.getOrderDetails()
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }

    //MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$orderDetails
            .compactMap { $0 }
            .sinkOnMain { [weak self] details in
                self?.view.isHidden = false
                self?.refreshControl.endRefreshing()
                self?.populate(with: details)
            }
            .store(in: &cancellables)

        viewModel.$cancelReasons
            .dropFirst()
            .filter { !$0.isEmpty }
            .sinkOnMain { [weak self] reasons in
                self?.showCancelReasonPopup(reasons: reasons)
            }
            .store(in: &cancellables)

        viewModel.$cancelSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result.message)
                self?.pop()
            }
            .store(in: &cancellables)

        viewModel.$rateSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result.message)

            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    //MARK: - Populate -

    private func populate(with details: OrderDetails) {
        orderNumberLabel.text = "order_num".localized + (details.orderNum ?? "")
        dateLabel.text = details.date
        timeLabel.text = details.time
        
        statusBarView.configure(currentStep: details.status?.key ?? 0, title: details.status?.title)
        tableView.reloadData()
        orderSummaryView.configure(dataSource: details.financials?.getDataSource() ?? [])
        if let delegateRate = details.delegateRates?.first {
            ratingView.configure(delegateRate: delegateRate, delegateName: details.delegate?.name ?? "")
        }

        if let delegate = details.delegate {
            driverInfoView.configure(delegate: delegate)
        }

        let showCancel = details.actions?.cancelButton ?? false
        let showRate   = details.actions?.rateButton   ?? false
        let showTrack  = details.actions?.trackButton  ?? false

        cancelButton.isHidden = !showCancel
        rateButton.isHidden  = !showRate
        trackButton.isHidden = !showTrack
        receivedButton.isHidden = true ///////
        ratingView.isHidden = !(details.isRated ?? false)
        statusBarView.isHidden = details.isStatusBarHidden
        driverInfoView.isHidden = details.isDelgateViewHidden
        invoiceButton.isHidden = details.isInvoiceButtonHidden

        if let notes = details.notes {
            clientNotesView.configure(title: "customer_notes".localized, content: notes)
            clientNotesView.isHidden = false
        } else {
            clientNotesView.isHidden = true
        }

        if let cancelledReason = details.cancelledReason {
            cancelReasonView.configure(title: "cancel_reason".localized, content: cancelledReason)
            cancelReasonView.isHidden = false
        } else {
            cancelReasonView.isHidden = true
        }
    }

    //MARK: - Rate Flow -

    private func showRatePopup() {
        let popup = RateOrderPopup()
        popup.orderId = viewModel.orderId
        popup.delegate = viewModel.orderDetails?.delegate
        popup.onConfirm = { [weak self] model in
            self?.viewModel.rateOrder(model: model)
        }
        popup.appear(sender: self)
    }
    
    func showBillPopup(url: String) {
        let vc = WebViewController()
        vc.urlString = url

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        present(nav, animated: true)
    }

    //MARK: - Cancel Flow -

    private func showCancelReasonPopup(reasons: [CancelReasonModel]) {
        let popup = CancelReasonPopup()
        popup.reasonList = reasons
        popup.onCancel = { [weak self] reason in
            self?.viewModel.cancelOrder(reasonId: reason.id ?? 0)
        }
        popup.appear(sender: self)
    }

    //MARK: - Actions -


    @objc private func refreshData() {
        viewModel.getOrderDetails()
    }

    @IBAction func didTapTrack(_ sender: UIButton) {

    }

    @IBAction func didTapCancel(_ sender: UIButton) {
        if viewModel.cancelReasons.isEmpty {
            viewModel.getCancelReasons()
        } else {
            showCancelReasonPopup(reasons: viewModel.cancelReasons)
        }
    }

    @IBAction func didTapRate(_ sender: UIButton) {
        showRatePopup()
    }
    
    @IBAction func didTapReceive(_ sender: UIButton) {
    }
    
    @IBAction func didTapInvoice(_ sender: UIButton) {
        guard let url = viewModel.orderDetails?.invoiceUrl else { return }
        showBillPopup(url: url)
    }
    
}

//MARK: - TableView -

extension OrderDetailsVC: UITableViewDataSource, UITableViewDelegate {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.register(cellType: ProductCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orderDetails?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProductCell.self, for: indexPath)
        if let item = viewModel.orderDetails?.items?[indexPath.row] {
            cell.setupCell(orderItem: item)
        }
        return cell
    }
}
