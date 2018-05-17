//
//  SwagReaderStore.swift
//  ApplePaySwag
//
//  Created by Satabdi Das on 16/05/18.
//  Copyright © 2018 Satabdi Das. All rights reserved.
//

import UIKit

struct SwagReaderStore {
    
    static let defaultSwagItems: [SwagItem] = {
        return parseSwagItems()
    }()
    
    private static func parseSwagItems() -> [SwagItem] {
        guard let fileURL = Bundle.main.url(forResource: "SwagItems", withExtension: "plist") else {
            return []
        }
        
        do {
            let swagData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let swagItems = try PropertyListDecoder().decode([SwagItem].self, from: swagData)
            return swagItems
        } catch {
            print(error)
            return []
        }
    }
}

