//
//  SchedualSlotViewController.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class SchedualSlotViewController: BaseViewController {
    
    //    @IBOutlet weak var TimeSlotcollection: UICollectionView!
    
    @IBOutlet weak var TimeSlotScrollview: UIScrollView!
    
    var arrTimeSlots:[String] = []
    var arrSelectedTimeSlots:[String] = []
    
    var arrDays:[String] = []
    var arrSlot:[String] = []
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetLayout()
        self.getCustomerAvailibility()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnAddAvaibility(_ sender: Any) {
        self.loading.startAnimating()
        let TimeAvailability = self.arrSelectedTimeSlots.joined(separator: ",")
        ApiService.instance.AddCustomerAvailibility(CustomerId: loadUser().id, TimeSlot: TimeAvailability) { (response) in
            self.loading.stopAnimating()
            guard let ResponseforOrderRequest:SetTimeSlotResponse = response as? SetTimeSlotResponse else {
                showAlert(self, ERROR, FAILURE_TO_SUBMIT)
                return
            }
            
            if ResponseforOrderRequest.totalRows != 0 {
               showAlert(self, SUCCESS, AVAILIBILITY_ADDED_SUCESSFULLY)
            }
        }
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


//MARK:- Private Methods

extension SchedualSlotViewController {
    
    func SetLayout() {
        self.loading.hidesWhenStopped = true
        
        self.arrDays = ["Lun","Mar","Mie","Jue","Vie","Sab","Dom"]
        self.arrSlot = ["10:00 - 12:00","12:00 - 14:00","14:00 - 16:00","16:00 - 18:00","18:00 - 20:00","20:00 - 22:00","22:00 - 24:00"]
//        self.arrSlot = ["00:00 - 02:00","02:00 - 04:00","04:00 - 06:00","06:00 - 08:00","08:00 - 10:00","10:00 - 12:00","12:00 - 14:00","14:00 - 16:00","16:00 - 18:00","18:00 - 20:00","20:00 - 22:00","22:00 - 24:00"]
        self.setGridView()
       
    }
    
    func getCustomerAvailibility(){
        self.loading.startAnimating()
        ApiService.instance.getCustomerAvailibility(CustomerId: loadUser().id) { (result) in
            self.loading.stopAnimating()
            guard let Availableresult: AvailibilityResponse = result as? AvailibilityResponse else {
                print("NO TypeOfBusiness were loaded from api")
                return
            }
            
            if let resultData:Availibility = Availableresult.data {
                self.arrSelectedTimeSlots = resultData.availability.components(separatedBy: ",")
                self.setGridView()
            }
//                self.MakeArrayFromString(JsonString: result.availability)
            
            
        }
    }
    
    func setGridView(){
        let arrScrollSubViews = self.TimeSlotScrollview.subviews
        
        for subView in arrScrollSubViews {
            subView.removeFromSuperview()
        }
        
        let ButtonHeight = 50
        var ButtonY = 5
        var ButtonX = ButtonHeight + 10
        
        var ContentHeight = 0
        var ContentWidth = 0
        
        var daycounter = 0
        
        for day in self.arrDays {
            daycounter = daycounter + 1
            let lblDay = UILabel(frame: CGRect(x: ButtonX, y: ButtonY, width: ButtonHeight, height: ButtonHeight))
            lblDay.textColor = UIColor.black
            lblDay.font = UIFont(name: "Helvetica", size: 12.0)
            lblDay.numberOfLines = 0
            lblDay.lineBreakMode = .byCharWrapping
            lblDay.textAlignment = .center
            lblDay.layer.borderColor = UIColor.black.cgColor
            lblDay.layer.borderWidth = 1.0
            lblDay.text = day
            ButtonX = ButtonX + ButtonHeight + 5
            self.TimeSlotScrollview.addSubview(lblDay)
            if daycounter == self.arrDays.count {
                ContentWidth = ButtonX
            }
        }
        
        ButtonX = 5
        ButtonY = ButtonY + ButtonHeight + 5
        var TimeCounter = 0
        for time in self.arrSlot {
            TimeCounter = TimeCounter + 1
            let lblDay = UILabel(frame: CGRect(x: ButtonX, y: ButtonY, width: ButtonHeight, height: ButtonHeight))
            lblDay.textColor = UIColor.black
            lblDay.font = UIFont(name: "Helvetica", size: 12.0)
            lblDay.numberOfLines = 0
            lblDay.layer.borderColor = UIColor.black.cgColor
            lblDay.layer.borderWidth = 1.0
            lblDay.lineBreakMode = .byCharWrapping
            lblDay.textAlignment = .center
            lblDay.text = time
            ButtonY = ButtonY + ButtonHeight + 5
            self.TimeSlotScrollview.addSubview(lblDay)
            if TimeCounter == self.arrSlot.count {
                ContentHeight = ButtonY
            }
        }
        
        self.TimeSlotScrollview.contentSize = CGSize(width: ContentWidth, height: ContentHeight)
        
        ButtonX = ButtonHeight + 10
        
        var DayWiseCounter = 0
        for DayName in self.arrDays {
            DayWiseCounter = DayWiseCounter + 1
            let DayLineView = UIView(frame: CGRect(x: ButtonX, y: ButtonHeight + 10, width: ButtonHeight, height: ContentHeight - (ButtonHeight + 10)))
            DayLineView.backgroundColor = UIColor.clear
            DayLineView.tag = DayWiseCounter
            
            ButtonY = 0
            var TimeWiseCounter = 0
            for TimeSlotName in self.arrSlot {
                TimeWiseCounter = TimeWiseCounter + 1
                let btnTime = UIButton(frame: CGRect(x: 0, y: ButtonY, width: ButtonHeight, height: ButtonHeight))
                btnTime.tag = TimeWiseCounter
                btnTime.addTarget(self, action: #selector(pressedAction(_:)) , for: .touchUpInside)
                let TimeSlot = "\(DayName) \(TimeSlotName)"
                if self.arrSelectedTimeSlots.contains(TimeSlot) {
                    btnTime.backgroundColor = UIColor(red: 30.0/255.0, green: 146.0/255.0, blue: 73.0/255.0, alpha: 1.0)
                }
                else {
                    btnTime.backgroundColor = UIColor.lightGray
                }
                DayLineView.addSubview(btnTime)
                ButtonY = ButtonY + ButtonHeight + 5
            }
            self.TimeSlotScrollview.addSubview(DayLineView)
            ButtonX = ButtonX + ButtonHeight + 5
        }
    }
    
    @objc func pressedAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let DayIndex = (sender.superview?.tag)! - 1
        let TimeIndex = sender.tag - 1
        
        let timeSlot = "\(self.arrDays[DayIndex]) \(self.arrSlot[TimeIndex])"
        
        //        let TimeSlot = self.arrTimeSlots[ButtonIndex]
        if self.arrSelectedTimeSlots.contains(timeSlot) {
            let Index = self.arrSelectedTimeSlots.index(of: timeSlot)
            self.arrSelectedTimeSlots.remove(at: Index!)
            sender.backgroundColor = UIColor.lightGray
        }
        else {
            sender.backgroundColor = UIColor(red: 30.0/255.0, green: 146.0/255.0, blue: 73.0/255.0, alpha: 1.0)
            self.arrSelectedTimeSlots.append(timeSlot)
        }
    }
}

////MARK:- UICollectionview Datasource & Delegate Methods
//
//extension SchedualSlotViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//    // MARK: Collection View
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.arrTimeSlots.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as! TimeSlotCollectionViewCell
//        let TimeSlot = self.arrTimeSlots[indexPath.row]
//        if self.arrSelectedTimeSlots.contains(TimeSlot) {
//            cell.lblTime.backgroundColor = UIColor.yellow
//        }
//        else {
//            cell.lblTime.backgroundColor = UIColor.gray
//        }
//        cell.lblTime.text = TimeSlot.replacingOccurrences(of: "-", with: " ")
////        cell.lblTime.tag = indexPath.row
////        cell.btnTimeSlot.setTitle(self.arrTimeSlots[indexPath.row], for: .normal)
////        cell.SelectTimeDelegate = self
//
////        cell.imgMenu.image = UIImage(named: self.arrMenuImages[indexPath.item])
////        cell.lblMenuName.text = self.arrMenu[indexPath.item]
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let TimeSlot = self.arrTimeSlots[indexPath.row]
//        if self.arrSelectedTimeSlots.contains(TimeSlot) {
//            let Index = self.arrSelectedTimeSlots.index(of: TimeSlot)
//            self.arrSelectedTimeSlots.remove(at: Index!)
//        }
//        else {
//            self.arrSelectedTimeSlots.append(TimeSlot)
//        }
//        self.TimeSlotcollection.reloadData()
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let widthHeight = (UIScreen.main.bounds.size.width - 40) / 7
//        //            ([[UIScreen mainScreen]bounds].size.width / 3 ) - 18;
//
//        return CGSize(width: widthHeight, height: widthHeight)
//    }
//
//
//}


//MARK:- SelectTimeSlotDelegate Method

//extension SchedualSlotViewController : SelectTimeSlotDelegate {
//
//    func selectButton(ButtonIndex: Int) {
//        let TimeSlot = self.arrTimeSlots[ButtonIndex]
//        if self.arrSelectedTimeSlots.contains(TimeSlot) {
//            let Index = self.arrSelectedTimeSlots.index(of: TimeSlot)
//            self.arrSelectedTimeSlots.remove(at: Index!)
//        }
//        else {
//            self.arrSelectedTimeSlots.append(TimeSlot)
//        }
//        self.TimeSlotcollection.reloadData()
//    }
//
//}

