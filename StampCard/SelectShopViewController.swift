//
//  SelectShopViewController.swift
//  StampCard
//
//  Created by Tsuneo Ootoshi on 2018/02/02.
//  Copyright © 2018年 Tsuneo Ootoshi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SelectShopViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    let defaultValues = UserDefaults.standard
    
    private var selectionsArray = [String]()
    var finalURL = ""
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var resLabel: UILabel!
    @IBOutlet weak var selectedShop: UILabel!
    @IBOutlet weak var saveCard: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        saveCard.isEnabled = false
        
        let urlString = "https://www.goodsystem27.com/getstampshop.php"
        let url = URL(string: urlString)
        
        guard let validUrl = url else {
            return
        }
        WebManager.downloadJson(from: validUrl) {(resArray) in
            
            self.selectionsArray = resArray
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        }
    }
    


    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return selectionsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectionsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.selectedRow(inComponent: 0) != 0){
            saveCard.isEnabled = true
        }else{
            saveCard.isEnabled = false
        }
        
        let urlString = "https://www.goodsystem27.com/getshopdetail.php?shopname="
        func urlEncode(string: String) -> String {
            return string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        }
        let jUrl = urlEncode(string: selectionsArray[row])
        let url = URL(string: urlString + jUrl)
        guard let finalUrl = url else {
            return
        }
        WebManager.downloadJson(from: finalUrl) {(resArray) in
            self.resLabel.text = String(describing: resArray[0])
        }
    }

    @IBAction func saveCardPressed(_ sender: Any) {
        let urlString = "https://www.goodsystem27.com/registercard.php?shopname="
        func urlEncode(string: String) -> String {
            return string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        }
        
        
        
        let userId = "&userId=" + defaultValues.string(forKey: "useremail")!
        
        let jUrl = urlEncode(string: selectionsArray[pickerView.selectedRow(inComponent: 0)])
        let url = URL(string: urlString + jUrl + userId)
        guard let finalUrl = url else {
            return
        }
        WebManager.downloadJson(from: finalUrl) {(resArray) in
            let answer = String(describing: resArray[0])
            if(answer == "success"){
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView") as! ProfileViewController
                self.navigationController?.pushViewController(profileViewController, animated: true)
               
                self.dismiss(animated: false, completion: nil)
            }else{
                self.createAlert(title: "スタンプカード追加", message: "カード追加できませんでした")
            }
        }
       
    }
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

class WebManager{
    
    class func downloadJson(from url:URL, completion:@escaping ([String])->Void){
        URLSession.shared.dataTask(with: url) {(data,response,error) in
            DispatchQueue.main.async {
                if error != nil{
                    completion([])
                }else{
                    guard let data = data else {
                        completion([])
                        return
                    }
                    let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves
                    )
                    guard let resArray = obj as? [String] else {
                        completion([])
                        return
                    }
                    completion(resArray)
                }
            }
        }.resume()
    }
    

}












