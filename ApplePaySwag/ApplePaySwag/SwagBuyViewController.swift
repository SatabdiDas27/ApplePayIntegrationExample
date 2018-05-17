//
//  SwagBuyViewController.swift
//  ApplePaySwag
//
//  Created by Satabdi Das on 16/05/18.
//  Copyright © 2018 Satabdi Das. All rights reserved.
//

import UIKit
import PassKit

class SwagBuyViewController: UIViewController {

    @IBOutlet weak var swagPriceLabel: UILabel!
    @IBOutlet weak var swagTitleLabel: UILabel!
    @IBOutlet weak var swagImage: UIImageView!
    @IBOutlet weak var applePayButton: UIButton!
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa,PKPaymentNetwork.discover]
    let ApplePaySwagMerchantID = "merchant.com.Infosys.ApplePaySwagV"
    let request =  PKPaymentRequest()
    
    var swag: SwagItem! {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        
        if (!self.isViewLoaded) {
            return
        }
        
        self.title = swag.title
        self.swagPriceLabel.text = "$" + swag.price
        self.swagImage.image = swag.image
        self.swagTitleLabel.text = swag.description
    }
    
    func createShippingAddressFromRef(address: PKContact) -> Address {
        var shippingAddress: Address = Address()
        
        shippingAddress.FirstName = address.name?.givenName
        shippingAddress.LastName = address.name?.familyName
        let postalAddress = address.postalAddress
        
        shippingAddress.Street = postalAddress?.street
        shippingAddress.City = postalAddress?.city
        shippingAddress.Zip = postalAddress?.postalCode
        shippingAddress.State = postalAddress?.state
        print(shippingAddress)
        
        return shippingAddress
        
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.applePayButton.isHidden = true
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks) {
            self.applePayButton.isHidden = false
        }
       
        
        
    }
    
    @IBAction func purchase(sender: UIButton) {
        // TODO: - Fill in implementation
        
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        var summaryItems = [PKPaymentSummaryItem]()
        summaryItems.append(PKPaymentSummaryItem(label: swag.title, amount: swag.priceAmountApplePay))
        
        if (swag.type == "Delivered") {
            summaryItems.append(PKPaymentSummaryItem(label: "Shipping", amount: swag.shippingPrice))
        }
        
        summaryItems.append(PKPaymentSummaryItem(label: "SAT-Inc", amount: swag.totalPrice))
        request.paymentSummaryItems = summaryItems
        
        switch swag.type {
            case "Delivered":
            request.requiredShippingContactFields = [PKContactField.postalAddress,PKContactField.phoneNumber]
            case "Electronic":
            request.requiredShippingContactFields = [PKContactField.emailAddress]
            default:
             break
        }
        
        if let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request){
            
            self.applePayButton.isHidden = false
            applePayController.delegate = self
            self.present(applePayController, animated: true, completion: nil)
        }
        
    }

}

extension SwagBuyViewController:PKPaymentAuthorizationViewControllerDelegate {
    internal func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                                    didAuthorizePayment payment: PKPayment,
                                                    handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: nil))
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didSelectShippingContact contact: PKContact,
                                            completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
        
        let shippingAddress = createShippingAddressFromRef(address: contact)
        
        switch (shippingAddress.State, shippingAddress.City, shippingAddress.Zip) {
        case (.some(let state), .some(let city), .some(let zip)):
            completion(PKPaymentAuthorizationStatus.success, [], [])
        default:
           // let shippingInvalidZip = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressPostalCodeKey,localizedDescription: "Invalid ZIP code")
            //let shippingInvalidStreet = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressStreetKey,localizedDescription: "Invalid street name")
            completion(PKPaymentAuthorizationStatus.failure, [], [])
        }
    }

   
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
