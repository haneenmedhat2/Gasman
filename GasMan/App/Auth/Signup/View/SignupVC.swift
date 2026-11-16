//
//  SignupVC.swift
//  Esterad
//
//  Created by Haneen on 18/10/2025.
//

import UIKit
import Combine

class SignupVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var profileImage: ProfileImageView!
    @IBOutlet weak var usernameTextField: GeneralTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var cityTextField: PickerFieldView!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var languageButton: IconTextGeneralButton!
    
    //MARK: - Properties -
    
    var viewModel : SignupVM
    override var navigationStyle: NavigationStyle { .white }
    
    //MARK: - Initializer -
    
    init(viewModel : SignupVM){
        self.viewModel = viewModel
        super.init(nibName: "SignupVC", bundle: nil)
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
        configureProfileImage()
        bindViewModel()
        setupChangeLanguage()

        cityTextField.delegate = self
    }
    
    func setupChangeLanguage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChangeLanguage))
        languageButton.addGestureRecognizer(tap)
        languageButton.buttonLabel.font = .systemFont(ofSize: 12)
    }
    
    //MARK: - View Configurations -
    
    private func configureProfileImage() {
        profileImage.setCameraAction(target: self, action: #selector(onCameraTap))
    }
    
    //MARK: - CheckBox Button  -
    
    private func updateCheckboxAppearance() {
        viewModel.isChecked.toggle()
        if viewModel.isChecked {
            checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    //MARK: - PickerPopup  -
    
    func showPickerPopup() {
        let popup = PickerListPopup()
        popup.allowMultipleSelection = false
        popup.pickerList = viewModel.citiesList
        popup.selectedItem = viewModel.selectedCity
        popup.onItemSelected = { [weak self] item in
            guard let self else { return }
            self.viewModel.selectedCity = item
            self.cityTextField.txtField.text = item?.pickerName
        }
        popup.appear(sender: self)
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        
        loading(viewModel.$isLoading)
        
        viewModel.$signup
            .dropFirst()
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                self.goToVerification()
            }
            .store(in: &cancellables)
        
        viewModel.$validation
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        viewModel.$citiesList
            .dropFirst()
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                self.showPickerPopup()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapCheckBox(_ sender: UIButton) {
        updateCheckboxAppearance()
    }
    
    @IBAction func didTapTermsAndConditions(_ sender: UIButton) {
        goToTermsAndConditions()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        goToLogin()
    }
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        let emailText = emailTextField.txtField.text?.trimWhiteSpace()
            let email = (emailText?.isEmpty == false) ? emailText : nil
            
            let model = SignupModel(
                name: usernameTextField.txtField.text,
                email: email,
                phone: phoneTextField.txtField.text,
                countryKey: "0996",
                cityId: viewModel.selectedCity?.pickerId,
                password: passwordTextField.txtField.text,
                confirmPassword: confirmPasswordTextField.txtField.text,
                avatar: viewModel.image
            )
            
            viewModel.validateUserData(model: model)
    }
    
    @objc func didTapChangeLanguage() {
        showLanguagePopup()
    }
    
    @objc func onCameraTap(){
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, imageData in
            guard let self = self else { return }
            self.profileImage.setImage(image)
            viewModel.image = imageData ?? Data()
        }
    }
}

//MARK: - Routes -

extension SignupVC {
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func goToLogin(){
        popToRoot()
    }
    
    func goToVerification(){
        guard let phone = phoneTextField.txtField.text else { return }
        let vc = VerificationVC(viewModel: VerificationVM( phone: phone))
        push(vc)
    }
    
    func goToTermsAndConditions(){
        let vc = TermsAndConditionsVC(viewModel: TermsAndConditionsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}

//MARK: - Delegate Confirmation -
extension SignupVC : PickerFieldViewDelegate {
    
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        
        if viewModel.citiesList.isEmpty {
            viewModel.getCities()
        } else {
            showPickerPopup()
        }
    }
}
