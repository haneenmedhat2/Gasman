//
//  OrderDetails.swift
//  GasMan
//
//  Created by Haneen on 02/03/2026.
//

struct OrderDetails: Codable {
    let id: Int?
    let orderNum: String?
    let date: String?
    let time: String?
    let status: StatusModel?
    let notes: String?
    let userPhone: String?
    let isRated: Bool?
    let deliveryCode: String?
    let cancelledReason: String?
    let statusBarImage: String?
    let statusBar: [StatusBar]?
    let financials: Financials?
    let address: Address
    let totalAvailableToRetrieve: Int?
    let items: [OrderItem]?
    let delegate: DelegateModel?
    let actions: OrderActions?
    let coupon: CouponModel?
    let myRates : [MyRates]?
    let delegateRates : [DelegateRate]?
    let invoiceUrl : String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNum = "order_num"
        case date
        case time
        case status
        case notes
        case userPhone = "user_phone"
        case isRated = "is_rated"
        case deliveryCode = "delivery_code"
        case cancelledReason = "cancelled_reason"
        case statusBarImage = "status_bar_image"
        case statusBar = "status_bar"
        case financials
        case address
        case totalAvailableToRetrieve = "total_available_to_retrieve"
        case items
        case delegate
        case actions
        case coupon
        case myRates = "my_rates"
        case delegateRates = "delegate_rates"
        case invoiceUrl = "invoice_url"
    }
}

extension OrderDetails {
    
    var isStatusBarHidden : Bool {
        return self.status?.key == 4
    }
    
    var isDelgateViewHidden : Bool {
        return self.status?.key == 0 ||  self.status?.key == 4
    }
    
    var isInvoiceButtonHidden : Bool {
        return self.status?.key == 0 ||  self.status?.key == 4
    }
}

struct StatusModel: Codable {
    let key: Int?
    let name: String?
    let title: String?
    let detailsText: String?

    enum CodingKeys: String, CodingKey {
        case key
        case name
        case title
        case detailsText = "details_text"
    }
}

struct StatusBar : Codable {
    let selected : String?
    let text : String
}

struct Financials: Codable {
    let address: String?
    let payType: String?
    let payStatus: String?
    let productPrice: String?
    let productsQty: Int?
    let adminCommissionAmount: String?
    let totalPartialProductsPrice: String?
    let deliveryPrice: String?
    let vatAmount: String?
    let couponValue: String?
    let totalPrice: String?
    let currency: String?
    let totalPriceBeforeDiscount : String?

    enum CodingKeys: String, CodingKey {
        case address
        case payType = "pay_type"
        case payStatus = "pay_status"
        case productPrice = "product_price"
        case productsQty = "products_qty"
        case adminCommissionAmount = "admin_commission_amount"
        case totalPartialProductsPrice = "total_partial_products_price"
        case deliveryPrice = "delivery_price"
        case vatAmount = "vat_amount"
        case couponValue = "coupon_value"
        case totalPrice = "total_price"
        case currency
        case totalPriceBeforeDiscount = "total_price_before_discount"
    }
}

struct Address: Codable {
    let mapDesc: String?
    let lat: Double?
    let lng: Double?

    enum CodingKeys: String, CodingKey {
        case mapDesc = "map_desc"
        case lat
        case lng
    }
}

struct OrderItem: Codable {
    let productId: Int?
    let title: String?
    let productTitle: String?
    let image: String?
    let qty: Int?
    let qtyPrice: String?
    let price: String?
    let totalPrice: String?
    let currency: String?
    let availableToRetrieve: Int?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case title
        case productTitle = "product_title"
        case image
        case qty
        case qtyPrice = "qty_price"
        case price
        case totalPrice = "total_price"
        case currency
        case availableToRetrieve
        case type
    }
}

struct OrderActions: Codable {
    let cancelButton: Bool?
    let trackButton: Bool?
    let rateButton: Bool?
    let showMyRatesButton: Bool?

    enum CodingKeys: String, CodingKey {
        case cancelButton = "cancel_button"
        case trackButton = "track_button"
        case rateButton = "rate_button"
        case showMyRatesButton = "show_my_rates_button"
    }
}

struct DelegateModel: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let phone: String?
    let carModel: String?
    let carType: String?
    let vehicleLicensePlate: String?
    let lat: Double?
    let lng: Double?
    let rate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case phone
        case carModel = "car_model"
        case carType = "car_type"
        case vehicleLicensePlate = "vehicle_license_plate"
        case lat
        case lng
        case rate
    }
}

struct MyRates : Codable {
    let comment : String?
    let id : Int?
    let image : String?
    let name : String?
    let rate : Int?
    let raterableType : String?

    enum CodingKeys: String, CodingKey {
        case comment
        case id
        case image
        case name
        case rate
        case raterableType = "raterable_type"
    }
}

struct DelegateRate : Codable {
    let comment : String?
    let id : Int?
    let rate : Int?
    let rateable : Rateable?
    let text : String?
}

struct Rateable : Codable {
    let id : Int?
    let image : String?
    let name : String?
}

struct CancelReasonModel: Codable {
    let id: Int?
    let title: String?
}

extension CancelReasonModel: SelectionModelPicker {
    var pickerId: Int { id ?? 0 }
    var pickerName: String { title ?? "" }
}

struct CouponModel: Codable {
    let id: Int?
    let name: String?
}

struct RateOrderModel: Codable {
    let orderId: Int?
    let orderRate: Int?
    let delegateComment: String?
    let delegateRate: Int?
    let carTypeRate: Int?
    let appRate: Int?
}

extension Financials {
    func getDataSource() -> [KeyValueModel] {
        [
            KeyValueModel(title: "delivery_address".localized, value: address),
            KeyValueModel(title: "payment_method".localized, value: payType),
            KeyValueModel(title: "payment_status".localized, value: payStatus),
            KeyValueModel(title: "unit_price".localized,value: productPrice?.toPrice),
            KeyValueModel(title: "subtotal".localized,value: totalPartialProductsPrice?.toPrice),
            KeyValueModel(title: "delivery_price".localized,value: deliveryPrice?.toPrice),
            KeyValueModel(title: "total_price".localized,value: totalPriceBeforeDiscount?.toPrice),
            KeyValueModel(title: "discount_coupon".localized,value: couponValue?.toPrice),
            KeyValueModel(title: "vat".localized,value: vatAmount?.toPrice),
            KeyValueModel(title: "total_after_discount".localized,value: totalPrice?.toPrice)
        ]
    }
}

