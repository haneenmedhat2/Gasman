//
//  UpdateProfileVC.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import UIKit
import Combine
import Kingfisher

class UpdateProfileVC: BaseViewController {
    
    //MARK: - Outlets -

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var usernameTextField: GeneralTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var cityTextField: PickerFieldView!
    
    //MARK: - Properties -
    
    var viewModel : UpdateProfileVM

    //MARK: - Initializer -
    
    init(viewModel : UpdateProfileVM){
        self.viewModel = viewModel
        super.init(nibName: "UpdateProfileVC", bundle: nil)
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
    
    private func initialConfiguration(){
        self.title = "edit_profile".localized
        setupUserData()
        configureProfileImage()
        bindViewModel()
        cityTextField.delegate = self
    }
        
    func setupUserData() {
        guard let user = Session.user else { return }
        emailTextField.txtField.text = user.email
        usernameTextField.txtField.text = user.name ?? ""
        cityTextField.txtField.text = user.city?.name
        profileImageView.setImage(url: user.image ?? "")
        viewModel.selectedCity = AreaModel(id: user.city?.id, name: user.city?.name)
    }
    
    private func configureProfileImage() {
        profileImageView.setCameraAction(target: self, action: #selector(onCameraTap))
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

    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$updateProfile
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                pop()
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
    
    //MARK: - Actions -
    
    @IBAction func didTapConfirmUpdate(_ sender: UIButton) {
        let username = usernameTextField.txtField.text
        let emailText = emailTextField.txtField.text?.trimWhiteSpace()
            let email = (emailText?.isEmpty == false) ? emailText : nil
        
        let model = UpdateProfileModel(
            image: viewModel.image,
            name: username,
            cityId: viewModel.selectedCity?.pickerId,
            email: email)
        
        viewModel.validateUserData(model: model)
    }
    
    @objc func onCameraTap(){
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, imageData in
            guard let self = self else { return }
            self.profileImageView.setImage(image)
            viewModel.image = imageData ?? Data()
        }
    }
}

//MARK: - Delegate Confirmation -
extension UpdateProfileVC : PickerFieldViewDelegate {
    
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        if viewModel.citiesList.isEmpty {
            viewModel.getCities()
        } else {
            showPickerPopup()
        }
    }
}
