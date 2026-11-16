//
//  LoginVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit
import Combine

class LoginVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var languageButton: IconTextGeneralButton!
    
    //MARK: - Properties -
    
    let viewModel : LoginVM
    override var navigationStyle: NavigationStyle { .white }
    
    //MARK: - Initializer -
    
    init(viewModel : LoginVM){
        self.viewModel = viewModel
        super.init(nibName: "LoginVC", bundle: nil)
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
        requestNotifications()
        setupChangeLanguage()
    }
    
    func setupChangeLanguage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChangeLanguage))
        languageButton.addGestureRecognizer(tap)
        languageButton.buttonLabel.font = .systemFont(ofSize: 12)
    }

    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$login
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                guard let result = result else { return }
                result.key == .needActive ? self.goToVerification() :self.goToHome()
            }
            .store(in: &cancellables)
        
        viewModel.$validationError
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    private func requestNotifications() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
    }
    
    //MARK: - Action -
    
    @IBAction func didTapForgetPassword(_ sender: UIButton) {
        goToForgetPassword()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        let phone = phoneTextField.txtField.text
        let password = passwordTextField.txtField.text
        viewModel.validateInputs(model: LoginModel(phone: phone, password: password))
    }
    
    @IBAction func didTapGuest(_ sender: UIButton) {
        UserDefaults.isLogin = false
        UserDefaults.guest = true
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    @IBAction func didTapCreateAccount(_ sender: UIButton) {
        goToSignup()
    }
    
    @objc func didTapChangeLanguage() {
        showLanguagePopup()
    }
}

//MARK: - Routes -

extension LoginVC {
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func goToSignup(){
        let vc = SignupVC(viewModel: SignupVM())
        push(vc)
    }
    
    func goToForgetPassword(){
        let vc = ForgetPasswordVC(viewModel: ForgetPasswordVM())
        push(vc)
    }
    
    func goToHome() {
        UserDefaults.isLogin = true
        UserDefaults.guest = false
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    func goToVerification(){
        guard let phone = phoneTextField.txtField.text else { return }
        let vc = VerificationVC(viewModel: VerificationVM(phone: phone))
        push(vc)
    }
}
