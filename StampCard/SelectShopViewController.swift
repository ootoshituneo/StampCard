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
    
    private var selectionsArray = [String]()
    var finalURL = ""
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var resLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func selet(_ sender: Any) {
        
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
            print(resArray[0])
            self.resLabel.text = String(describing: resArray[0])
         //   print(resArray)
//            self.selectionsArray = resArray
//            self.pickerView.delegate = self
//            self.pickerView.dataSource = self
        }
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
    
//    class func dowloadDetail(from url:URL,completion:@escaping([String])->Void){
//        URLSession.shared.dataTask(with: url) {(data,response,error) in
//            DispatchQueue.main.async {
//                if error != nil{
//                    completion([])
//                }else{
//                    guard let data = data else {
//                        completion([])
//                        return
//                    }
//                    let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves
//                    )
//                    guard let resArray = obj as? [String] else {
//                        completion([])
//                        return
//                    }
//                    completion(resArray)
//                }
//            }
//            }.resume()
//
//    }


    
    
}












