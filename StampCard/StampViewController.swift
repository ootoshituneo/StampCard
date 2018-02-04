//
//  StampViewController.swift
//  StampCard
//
//  Created by Tsuneo Ootoshi on 2018/01/27.
//  Copyright © 2018年 Tsuneo Ootoshi. All rights reserved.
//

import UIKit

class StampViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var labelShopName: UILabel!
    
    var array : [String] = []
    var shopName : String?
    var stampCount : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       labelShopName.text = shopName!
        let num: Int = Int(stampCount!)!
        if(num != 0){
            for _ in 1...num {
                array.append("mac_02")
            }
        }
        
    
        
        let itemsize = UIScreen.main.bounds.width/5 - 5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.itemSize = CGSize(width: itemsize, height: itemsize)
        
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        myCollectionView.collectionViewLayout = layout

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StampCell
        cell.myStampView.image = UIImage(named: array[indexPath.row] + ".jpg")
        return cell
    }
}
