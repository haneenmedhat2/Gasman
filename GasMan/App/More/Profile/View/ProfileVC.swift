//
//  ProfileVC.swift
//  Esterad
//
//  Created by Haneen on 02/11/2025.
//

import UIKit
import Kingfisher
import Combine

class ProfileVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var usernameTextField: GeneralTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var cityTextField: GeneralTextField!
    
    //MARK: - Properties -
    
    let viewModel : ProfileVM
    
    //MARK: - Initializer -
    
    init(viewModel : ProfileVM){
        self.viewModel = viewModel
        super.init(nibName: "ProfileVC", bundle: nil)
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
        self.title = "profile".localized
        setupUserData()
        viewModel.profileRequest()
        bindViewModel()

        phoneTextField.txtField.textColor = .hint
        usernameTextField.txtField.textColor = .hint
        emailTextField.txtField.textColor = .hint
        cityTextField.txtField.textColor = .hint
    }
    
    private func bindViewModel() {
        viewModel.profile
            .sinkOnMain { [weak self] user in
                guard let self = self else { return }
                self.setupUserData()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Setup Data -
    
    func setupUserData() {
        guard let user = Session.user else { return }
        
        if let email = user.email , !email.trimWhiteSpace().isEmpty {
            emailTextField.txtField.text = user.email
        } else {
            emailTextField.isHidden = true
        }
        
        usernameTextField.txtField.text = user.name ?? ""
        phoneTextField.txtField.text = user.fullPhone ?? ""
        cityTextField.txtField.text = user.city?.name
        profileImageView.setImage(url: user.image ?? "")
    }
}
