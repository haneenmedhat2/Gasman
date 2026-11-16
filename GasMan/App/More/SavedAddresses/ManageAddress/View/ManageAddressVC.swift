//
//  ManageAddressVC.swift
//  GasMan
//
//  Created by Haneen on 17/02/2026.
//

import UIKit
import Combine
import CoreLocation
import GoogleMaps

class ManageAddressVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: GeneralTextField!
    @IBOutlet weak var cityTextField: PickerFieldView!
    @IBOutlet weak var streetTextField: GeneralTextField!
    @IBOutlet weak var buildingNumTextField: GeneralTextField!
    @IBOutlet weak var confirmButton: MainButton!
    
    //MARK: - Properties -

    weak var delegate: ManageAddressVCDelegate?
    var viewModel : ManageAddressVM
    private let locationManager = CLLocationManager()
    private var currentLat: Double?
    private var currentLng: Double?
    private let geocoder = GMSGeocoder()
    
    //MARK: - Initializer -
    
    init(viewModel : ManageAddressVM){
        self.viewModel = viewModel
        super.init(nibName: "ManageAddressVC", bundle: nil)
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
        self.title = viewModel.mode.title
        confirmButton.setTitle(viewModel.mode.buttonTitle, for: .normal)
        bindViewModel()
        cityTextField.delegate = self
        setupLocation()
        setupMap()
        if viewModel.mode == .updateAddress {
            configureIfUpdateMode()
        } else {
            handleLocationPermission()
        }
    }
    
    private func configureIfUpdateMode() {
        guard let model = viewModel.model else { return }
        
        addressTextField.txtField.text = model.name
        cityTextField.txtField.text = model.city?.name
        
        streetTextField.txtField.text = model.streetName
        buildingNumTextField.txtField.text = model.buildingNumber
        addressLabel.text = model.mapDesc
        
        if let lat = model.lat, let lng = model.lng {
            currentLat = lat
            currentLng = lng
            updateMapAndAddress(latitude: currentLat ?? 0.0, longitude: currentLng ?? 0.0)
        }
        
        if let city = model.city {
            viewModel.selectedCity = city
        }
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func setupMap() {
        mapview.delegate = self
        mapview.isMyLocationEnabled = false
        if let scrollView = mapview.superview?.superview as? UIScrollView {
            scrollView.delaysContentTouches = false
        }
    }
    
    private func handleLocationPermission() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            showLocationPermissionAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        @unknown default:
            break
        }
    }
    
    private func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "location_permission_title".localized,
            message: "location_permission_message".localized,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))

        alert.addAction(UIAlertAction(title: "open_settings".localized, style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })

        present(alert, animated: true)
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$storeAddress
            .compactMap{ $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                delegate?.manageAddressDidSave()
                showPopup(title : result?.message ?? "")
            }
            .store(in: &cancellables)

        viewModel.$citiesList
            .dropFirst()
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                self.showPickerPopup()
            }
            .store(in: &cancellables)
        
        viewModel.$validation
            .compactMap{ $0 }
            .sinkOnMain { [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error?.localizedDescription ?? "")
            }
            .store(in: &cancellables)
        
        
        error(viewModel.$error)
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
    
    //MARK: - Actions -
    
    @IBAction func didTapCurrentLocation(_ sender: UIButton) {
        handleLocationPermission()

    }
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        guard let lat = currentLat,
                let lng = currentLng else {
              return
          }
          
          let model = ManageAddress(
              name: addressTextField.txtField.text,
              mapDesc: addressLabel.text,
              lat: lat,
              lng: lng,
              cityId: viewModel.selectedCity?.pickerId,
              buildingNumber: buildingNumTextField.txtField.text,
              streetName: streetTextField.txtField.text,
              locationId: viewModel.model?.id
          )
        
        viewModel.validateData(model: model)
    }
}


extension ManageAddressVC: CLLocationManagerDelegate , GMSMapViewDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        
        updateMapAndAddress(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    func mapView(_ mapView: GMSMapView,
                 didTapAt coordinate: CLLocationCoordinate2D) {
        
        updateMapAndAddress(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }
    
    private func updateMapAndAddress(latitude: Double, longitude: Double) {
        
        currentLat = latitude
        currentLng = longitude
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16)
        mapview.animate(to: camera)
        
        mapview.clear()
        
        let marker = GMSMarker(position: coordinate)
        marker.map = mapview
        
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, _ in
            guard let self else { return }
            
            if let address = response?.firstResult(),
               let lines = address.lines {
                self.addressLabel.text = lines.joined(separator: ", ")
            } 
        }
    }
}

// MARK: - ManageAddressVCDelegate -

protocol ManageAddressVCDelegate: AnyObject {
    func manageAddressDidSave()
}

//MARK: - Delegate Confirmation -

extension ManageAddressVC : PickerFieldViewDelegate {
    
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        if viewModel.citiesList.isEmpty {
            viewModel.getCities()
        } else {
            showPickerPopup()
        }
    }
}

//MARK: - Routes -

extension ManageAddressVC {
    func showPopup(title : String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            pop()
        }
    }
}
