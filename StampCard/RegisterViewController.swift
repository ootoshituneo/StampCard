//
//  RegisterViewController.swift
//  StampCard
//
//  Created by Tsuneo Ootoshi on 2018/01/30.
//  Copyright © 2018年 Tsuneo Ootoshi. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController,UITextFieldDelegate{
    
    let defaultValues = UserDefaults.standard

    let URL_USER_REGISTER = "https://www.goodsystem27.com/registration.php"
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldUserEmail: UITextField!
    
    @IBOutlet weak var textFieldUserPassword: UITextField!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldUsername.delegate = self
        textFieldUserPassword.delegate = self
        textFieldUserEmail.delegate = self
        
        if defaultValues.string(forKey: "username") != nil{
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
        
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
                
    ////
                if let result = response.result.value {
                    
                    let jsonData = result as! NSDictionary
                    
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        let userName = user.value(forKey: "username") as! String
                        let userEmail = user.value(forKey: "email") as! String
                        let uId = user.value(forKey: "uid") as! String
                        
                        //    saving user values to defaults
                 
                        self.defaultValues.set(userName, forKey: "username")
                        self.defaultValues.set(userEmail, forKey: "useremail")
                        self.defaultValues.set(uId, forKey: "uid")
                        
                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView") as! ProfileViewController
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                        
                        self.dismiss(animated: false, completion: nil)
                    }
                    }
                
                
//    /////
//                if let result = response.result.value {
//                    let jasonData = result as! NSDictionary
//                    let error = jasonData.value(forKey: "error")
//
//                    let errorNum : Int = Int(String(describing: error!))!
//
//                    if(Int(errorNum) == 0){
//                        let next = self.storyboard!.instantiateViewController(withIdentifier: "MakeCard")
//                        self.present(next,animated: true, completion: nil)
//
//                        self.defaultValues.set(userId, forKey: "userid")
//                        self.defaultValues.set(userName, forKey: "username")
//                        self.defaultValues.set(userEmail, forKey: "useremail")
//
//
//                    } else {
//                         self.labelMessage.text = jasonData.value(forKey: "message") as! String?
//                    }
//                }
                
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
