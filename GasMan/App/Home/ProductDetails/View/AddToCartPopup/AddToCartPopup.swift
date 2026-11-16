//
//  AddToCartPopup.swift
//  GasMan
//
//  Created by Haneen on 23/02/2026.
//

import UIKit
import SDWebImage

class AddToCartPopup: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gifImageView: UIImageView!
    
    //MARK: - Properties -
    
    var delegate : AddToCartPopupProtocol?

    //MARK: - Initializer  -
    
    init() {
        super.init(nibName: "AddToCartPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    //MARK: - View Configuration -
    
    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor  = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        contentView.isUserInteractionEnabled = true
        setupView()
    }
    
    func setupView() {
        if let url = Bundle.main.url(forResource: "Shoping Cart", withExtension: "gif") {
            gifImageView.sd_setImage(with: url)
        }
    }
    
    func appear(sender:UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
    }
    
    func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){ }
        }
    }
    
    func hide(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false){
            }
            self.removeFromParent()
        }
    }
    
    //MARK: - Actions -
    
    
    @IBAction func didTapGoToCart(_ sender: UIButton) {
        delegate?.didTapOnGoToCart()
        hide()
    }
    
    @IBAction func didTapContinue(_ sender: UIButton) {
        delegate?.didTapOnContinueShopping()
        hide()
    }
    
}

protocol AddToCartPopupProtocol : AnyObject {
    func didTapOnGoToCart()
    func didTapOnContinueShopping()
}
