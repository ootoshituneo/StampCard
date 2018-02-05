//
//  ProfileViewController.swift
//  StampCard
//
//  Created by Tsuneo Ootoshi on 2018/01/26.
//  Copyright © 2018年 Tsuneo Ootoshi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayQR: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    let defaultValues = UserDefaults.standard
    
    //private var shops = [Shops]()
    var shops : [[String: String?]] = []
    var selectedShopName : String = ""
    var selectedStampCount : String = ""
    var filter:CIFilter!
    var userEmail : String = ""
    var uid : String = ""
    
    let GET_SHOP_URL = "https://www.goodsystem27.com/getshops.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        displayQR.isHidden = true
        
        //hiding back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton

        //getting user data from defaults
        let defaultValues = UserDefaults.standard
        if let userName = defaultValues.string(forKey: "username"){
            //setting the name to label
            labelUsername.text = userName
        } else {

        }

        userEmail = defaultValues.string(forKey: "useremail")!
        uid = defaultValues.string(forKey: "uid")!
        
        print(uid)

        //getDhopData
        downloadShopData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func downloadShopData(){
        let parameters: Parameters=[
            "useremail":userEmail
        ]
        
        Alamofire.request(GET_SHOP_URL, method: .get, parameters: parameters).responseJSON
            {
                response in
                guard let object = response.result.value else{
                    return
                }
                
                let json = JSON(object)
                json.forEach{(_,json) in
                    
                    let shop : [String: String?] = [
                        "shopId":json["shopId"].string,
                        "shopName":json["shopName"].string,
                        "stampCount":json["stampCount"].string
                    ]
                    self.shops.append(shop)
                }
               // print(self.shops.count)
                self.tableView.reloadData()
            }
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopNameCell", for: indexPath) as! ShopCell
       
        let shop = shops[indexPath.row]
        cell.labelShopName.text = shop["shopName"]!
        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shop = shops[indexPath.row]
        selectedShopName = shop["shopName"]!!
        selectedStampCount = shop["stampCount"]!!
        performSegue(withIdentifier: "showStamp",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showStamp") {
            let secondVC: StampViewController = (segue.destination as? StampViewController)!
            
            // 11. SecondViewControllerのtextに選択した文字列を設定する
            secondVC.shopName = selectedShopName
            secondVC.stampCount = selectedStampCount
        }
        
    }
    
    func updateTableView() {
        setUp()
        self.tableView.reloadData()
    }
    
    func setUp(){
        let parameters: Parameters=[
            "useremail":userEmail
        ]
        
        Alamofire.request(GET_SHOP_URL, method: .get, parameters: parameters).responseJSON
            {
                response in
                guard let object = response.result.value else{
                    return
                }
                
                let json = JSON(object)
                json.forEach{(_,json) in
                    
                    let shop : [String: String?] = [
                        "shopId":json["shopId"].string,
                        "shopName":json["shopName"].string,
                        "stampCount":json["stampCount"].string
                    ]
                    self.shops.append(shop)
                }
                // print(self.shops.count)
                self.tableView.reloadData()
        }
    }


    @IBAction func qrSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            tableView.isHidden = true
            let uid =  defaultValues.string(forKey: "uid")!
            let data = uid.data(using: .ascii,allowLossyConversion: false)
            filter = CIFilter(name: "CIQRCodeGenerator")
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX:10,y:10)
            let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
            displayQR.image = image
            displayQR.isHidden = false
        }else{
             tableView.isHidden = false
             displayQR.isHidden = true
        }
    }
    
    
    
}



