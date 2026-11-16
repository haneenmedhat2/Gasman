//
//  HomeVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit
import Combine

class HomeVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties -
    
    let viewModel : HomeVM
    let refreshController = UIRefreshControl()

    private var sections: [HomeSection] {
        var result: [HomeSection] = []
        
        if !viewModel.sliderList.isEmpty {
            result.append(.slider)
        }
        
        for index in viewModel.categoryList.indices {
            result.append(.category(index))
        }
        
        return result
    }
    
    //MARK: - Initializer -
    
    init(viewModel : HomeVM){
        self.viewModel = viewModel
        super.init(nibName: "HomeVC", bundle: nil)
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
        setupNotificationButton()
        setupLeftBarButton()
        configureCollectionView()
        viewModel.gethomeData()
    }
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$home
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.refreshController.endRefreshing()
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Action -
    
    @objc func refreshData(){
        viewModel.gethomeData()
    }
}

//MARK: - Collection View Setup -

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmptyStateCell.self, forCellWithReuseIdentifier: "EmptyStateCell")
        collectionView.register(BannerSliderCell.self, forCellWithReuseIdentifier: "BannerSliderCell")
        collectionView.register(cellType: CategoryCell.self)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: CollectionHeaderView.elementKind,
                                withReuseIdentifier: CollectionHeaderView.headerIdentifier)
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            switch self.sections[sectionIndex] {
                
            case .slider:
                return self.adsSection()
                
            case .category(let index):
                let category = self.viewModel.categoryList[index]
                let isEmpty = category.products?.isEmpty ?? true
                return self.productsGridSection(isEmpty: isEmpty)
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)

        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshController
    }
    
    
    func adsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(190)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        return section
    }
    
    func productsGridSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        
        if isEmpty {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(160)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: itemSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = headerItem()
            return section
        }
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(250)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(250)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = headerItem()
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

        return section
    }

    private func headerItem() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(46)
            ),
            elementKind: CollectionHeaderView.elementKind,
            alignment: .top
        )

        header.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return [header]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
            
        case .slider:
            return 1
            
        case .category(let index):
            let products = viewModel.categoryList[index].products
            return products?.isEmpty ?? true ? 1 : products!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
            
        case .slider:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "BannerSliderCell",
                for: indexPath
            ) as! BannerSliderCell
            
            cell.configure(list: viewModel.sliderList)
            return cell
            
        case .category(let index):
            
            let category = viewModel.categoryList[index]
            
            guard let products = category.products, !products.isEmpty else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "EmptyStateCell",
                    for: indexPath
                ) as! EmptyStateCell
                
                cell.configure(
                    image: .CARD,
                    message: "no_products".localized
                )
                return cell
            }
            
            let product = products[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(
                with: CategoryCell.self,
                for: indexPath
            )
            
            cell.setupCell(model: product)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .category(let index):
            if Session.isGuest ?? false {
                let vc = GuestLoginPopup()
                vc.appear(sender: self)
                return
            } else {
                let category = viewModel.categoryList[index]
                let product = category.products?[indexPath.row]
                guard let product = product else { return }
                goToProductDetails(productId: product.id ?? 0)
            }
        default :
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: CollectionHeaderView.elementKind,
            withReuseIdentifier: CollectionHeaderView.headerIdentifier,
            for: indexPath
        ) as! CollectionHeaderView
        
        switch sections[indexPath.section] {
            
        case .slider:
            header.isHidden = true
            
        case .category(let index):
            header.isHidden = false
            header.configure(title: viewModel.categoryList[index].name ?? "")
        }
        
        return header
    }
}

//MARK: - Routes -

extension HomeVC {
    func goToProductDetails(productId : Int){
        let vc = ProductDetailsVC(viewModel: ProductDetailsVM(productId: productId))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
