//
//  ItemRegisterViewController.swift
//  OpenMarket
//
//  Created by WANKI KIM on 2021/08/23.
//

import UIKit

class ItemRegisterViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    @IBAction func clickCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
