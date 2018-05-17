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
        let request =  PKPaymentRequest()
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: swag.title, amount: swag.priceAmountApplePay),
            PKPaymentSummaryItem(label: "Infosys-Apple", amount: swag.priceAmountApplePay)
        ]
        if let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request){
            
            self.applePayButton.isHidden = false
            applePayController.delegate = self
            self.present(applePayController, animated: true, completion: nil)
        }
        
    }

}

extension SwagBuyViewController:PKPaymentAuthorizationViewControllerDelegate {
    private func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
