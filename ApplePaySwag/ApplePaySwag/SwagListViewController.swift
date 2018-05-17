//
//  SwagListViewController.swift
//  ApplePaySwag
//
//  Created by Satabdi Das on 16/05/18.
//  Copyright © 2018 Satabdi Das. All rights reserved.
//

import UIKit

class SwagListViewController: UITableViewController {

    var swagList = SwagReaderStore.defaultSwagItems
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segueIdentifier(for: segue) == .showBuyView,
            let destinationViewController = segue.destination as? SwagBuyViewController,
            let indexPath = self.tableView.indexPathForSelectedRow{
               let swagItem = swagList[indexPath.row]
               destinationViewController.swag = swagItem
        }
    }
    
  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return swagList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwagCell", for: indexPath as IndexPath) as! SwagCellTableViewCell
        
        let object = swagList[indexPath.row]
        cell.titleLabel.text = object.title
        cell.priceLabel.text = "$" + object.price
        cell.swagImage.image = object.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 107
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }

   

}

extension SwagListViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case showBuyView
    }
}
