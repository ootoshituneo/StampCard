//
//  StampViewController.swift
//  StampCard
//
//  Created by Tsuneo Ootoshi on 2018/01/27.
//  Copyright © 2018年 Tsuneo Ootoshi. All rights reserved.
//

import UIKit

class StampViewController: UIViewController {

    
    @IBOutlet weak var labelShopname: UILabel!
    
    var shopName : String?
    var stampCount : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelShopname.text = shopName!
        let num: Int = Int(stampCount!)!
        
        print(num)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
