//
//  MoreVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit
import Combine

class MoreVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    let viewModel : MoreVM
    
    //MARK: - Initializer -
    
    init(viewModel : MoreVM){
        self.viewModel = viewModel
        super.init(nibName: "MoreVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
        bindViewModel()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        configureTableView()
        setupNotificationButton()
        setupLeftBarButton()
    }
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        viewModel.signout
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.goToSplashScreen()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
}

//MARK: - Tableview Configuration -

extension MoreVC : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: MoreCell.self, bundle: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MoreCell.self, for: indexPath)
        let item = viewModel.menuItems[indexPath.row]
        cell.setupCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.menuItems[indexPath.row]
        handleMenuSelection(item)
    }
    
    private func handleMenuSelection(_ item: MoreMenuItem) {
       switch item {
        case .profile:
            goToProfile()
        case .settings:
           goToSettigns()
       case .savedAddresses:
           goToSavedAddresses()
       case .aboutUs:
           goToAboutUs()
        case .termsAndConditions:
           goToTermsAndConditions()
        case .complaints:
           goToComplaints()
        case .contactUs:
           goToContactUs()
        case .logout:
           viewModel.signoutRequest()
        case .changeLanguage:
           showLanguagePopup()
       case .wallet:
           goToWallet()
       case .FAQ:
           goToFAQ()
       case .myRatings:
           goToMyRatings()
       case .privacyPolicy:
           goToPrivacyPolicy()
       case .shareApp:
           AppHelper.openUrl("itms-apps://itunes.apple.com")
       default:
           break
       }
    }
}

//MARK: - Routes -

extension MoreVC {
    func goToProfile(){
       let vc =  ProfileVC(viewModel: ProfileVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToUpdateProfile(){
        let vc = UpdateProfileVC(viewModel: UpdateProfileVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToSettigns(){
        let vc = SettingsVC(viewModel: SettingsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToWallet(){
        let vc = WalletVC(viewModel: WalletVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToSavedAddresses(){
        let vc = SavedAddressesVC(viewModel: SavedAddressesVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToComplaints(){
        let vc = ComplaintsVC(viewModel: ComplaintsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
        
    func goToContactUs(){
        let vc = ContactUsVC(viewModel: ContactUsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToFAQ(){
        let vc = FAQVC(viewModel: FAQVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToTermsAndConditions(){
        let vc = TermsAndConditionsVC(viewModel: TermsAndConditionsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToAboutUs(){
        let vc = AboutUsVC(viewModel: AboutUsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToPrivacyPolicy(){
        let vc = PrivacyPolicyVC(viewModel: PrivacyPolicyVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToMyRatings(){
        let vc = MyRatingsVC(viewModel: MyRatingsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToSplashScreen(){
        UserDefaults.isLogin = false
        UserDefaults.guest = true
        Session.user = nil
        Session.token = nil
        UserDefaults.isNotify = true

        let splashVC = SplashVC()
        AppHelper.changeWindowRoot(vc: splashVC)
    }
        
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func showGuestPopup(){
        let vc = GuestLoginPopup()
        vc.appear(sender: self)
    }
}

//MARK: - Double Action Popup  Delegation  -

extension MoreVC : DoubleActionPopupProtocol {
    func didTapSecondAction() {
        viewModel.signoutRequest()
    }
}
