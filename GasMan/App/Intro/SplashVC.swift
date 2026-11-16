//
//  SpalshVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit

class SplashVC : UIViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet private weak var iconImage: UIImageView!

    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }
    
    //MARK: - Initail Setup -
    
    private func setupAnimation() {
        view.backgroundColor = .white
        iconImage.alpha = 0
        iconImage.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height / 4)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut) {
            self.iconImage.alpha = 1
            self.iconImage.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.goToNext()
        }
    }
}

//MARK: - Routes-

extension SplashVC {
    
    private func goToNext() {
        if UserDefaults.isLogin {
            goToHome()
        } else {
            goToLogin()
        }
    }
    
    private func goToHome(){
        UserDefaults.isLogin = true
        UserDefaults.guest = false
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    private func goToLogin() {
        UserDefaults.isFirstTime = false
        UserDefaults.guest = true
        UserDefaults.isLogin = false
        let vc = LoginVC(viewModel: LoginVM())
        let nav  = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
}

