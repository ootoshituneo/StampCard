//
//  RegisterViewController.swift
//  StampCard
//
//  Created by Tsuneo Ootoshi on 2018/01/30.
//  Copyright © 2018年 Tsuneo Ootoshi. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    let URL_USER_REGISTER = "https://www.goodsystem27.com/registration.php"
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldUserEmail: UITextField!
    
    @IBOutlet weak var textFieldUserPassword: UITextField!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    @IBAction func buttonRegister(_ sender: Any) {
        
        let parameters: Parameters = [
            
            "username":textFieldUsername.text!,
            "email":textFieldUserEmail.text!,
            "password":textFieldUserPassword.text!
           
        ]
        
        //Sending http post request
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON
            {
                response in
                print(response)
                
                if let result = response.result.value {
                    let jasonData = result as! NSDictionary
                    let error = jasonData.value(forKey: "error")
                    
                    let errorNum : Int = Int(String(describing: error!))!
                    
                    if(Int(errorNum) == 0){
                        let next = self.storyboard!.instantiateViewController(withIdentifier: "MakeCard")
                        self.present(next,animated: true, completion: nil)
                    } else {
                         self.labelMessage.text = jasonData.value(forKey: "message") as! String?
                    }
                }
                
        }
        
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
