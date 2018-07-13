//
//  WholesalerCommercialVisitViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit
import CarbonKit

class WholesalerCommercialVisitViewController: BaseViewController , CarbonTabSwipeNavigationDelegate {

    @IBOutlet var vwContainer : UIView?
    
    var tabSwipe = CarbonTabSwipeNavigation()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Visitas comerciales"
        
        tabSwipe = CarbonTabSwipeNavigation(items: ["Enviar propuestas", "Notificaciones"], delegate: self)
        tabSwipe.carbonSegmentedControl?.backgroundColor = UIColor.white
        tabSwipe.setNormalColor(UIColor.gray)
        tabSwipe.setSelectedColor(UIColor.gray)
        tabSwipe.carbonTabSwipeScrollView.backgroundColor = UIColor.white
        tabSwipe.carbonTabSwipeScrollView.isScrollEnabled = false
        tabSwipe.setIndicatorColor(UIColor(red:15.0/255.0, green: 98.0/255.0, blue: 40.0/255.0, alpha: 1.0))
        tabSwipe.carbonSegmentedControl?.setWidth(self.view.bounds.size.width/2, forSegmentAt: 0)
        tabSwipe.carbonSegmentedControl?.setWidth(self.view.bounds.size.width/2, forSegmentAt: 1)
        tabSwipe.insert(intoRootViewController: self)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.SinglePostScreen(notification:)), name: Notification.Name("SinglePost"), object:nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.ProfileScreen(notification:)), name: Notification.Name("Profile"), object:nil)
        
    }
    
    func Back() {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if index == 0 {
            return self.storyboard!.instantiateViewController(withIdentifier: "BussinessRequirementFormViewController")
        }
        return self.storyboard!.instantiateViewController(withIdentifier: "WholesalerBusinessNotificationViewController")
    }
    
//    func SinglePostScreen(notification:Notification) {
//        let user_info:Dictionary<String,Any> = notification.userInfo as! Dictionary<String, Any>
//
//        let vc:SinglePostViewController = self.storyboard?.instantiateViewController(withIdentifier: "SinglePostViewController") as! SinglePostViewController
//        vc.str_CatptureId = user_info["id"] as! Int
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func ProfileScreen(notification:Notification) {
//        let user_info:Dictionary<String,Any> = notification.userInfo as! Dictionary<String, Any>
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
//        newViewController.selectedUserID = user_info["id"] as! Int
//        self.navigationController?.pushViewController(newViewController, animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
