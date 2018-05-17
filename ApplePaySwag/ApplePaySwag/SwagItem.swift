//
//  SwagItem.swift
//  ApplePaySwag
//
//  Created by Satabdi Das on 16/05/18.
//  Copyright © 2018 Satabdi Das. All rights reserved.
//

import UIKit

/*enum SwagType {
    case Delivered
    case Electronic
    
}

func ==(lhs: SwagType, rhs: SwagType) -> Bool {
    switch(lhs, rhs) {
    case (.Delivered, .Delivered):
        return true
    case (.Electronic, .Electronic):
        return true
    default: return false
    }
}*/

struct SwagItem: Decodable {

    let type: String
    let description: String
    let image: UIImage
    let title: String
    let price: String
    let shippingPrice: NSDecimalNumber = NSDecimalNumber(string: "5.0")
    
    var priceAmountApplePay : NSDecimalNumber {
        let number = NSDecimalNumber(string: price)
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let finalString = numberFormatter.string(from: number)
        
        return NSDecimalNumber(string: finalString)
    }
    
    var totalPrice : NSDecimalNumber {
        if type == "Delivered" {
            return priceAmountApplePay.adding(shippingPrice)
        }
        return priceAmountApplePay
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case description
        case image
        case title
        case price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(String.self, forKey: .price)
        type = try container.decode(String.self, forKey: .type)
        let imageName = try container.decode(String.self, forKey: .image)
        image = UIImage(named: imageName)!
        
    }
}
