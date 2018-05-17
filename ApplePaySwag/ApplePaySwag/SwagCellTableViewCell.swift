//
//  SwagCellTableViewCell.swift
//  ApplePaySwag
//
//  Created by Satabdi Das on 16/05/18.
//  Copyright © 2018 Satabdi Das. All rights reserved.
//

import UIKit

class SwagCellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var swagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
