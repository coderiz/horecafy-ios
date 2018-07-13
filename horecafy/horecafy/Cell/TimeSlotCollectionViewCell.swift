//
//  TimeSlotCollectionViewCell.swift
//  horecafy
//
//  Created by iOS User 1 on 06/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

protocol SelectTimeSlotDelegate {
    func selectButton(ButtonIndex:Int)
}

class TimeSlotCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var btnTimeSlot: UIButton!
    
    @IBOutlet weak var lblTime: UILabel!
    var SelectTimeDelegate:SelectTimeSlotDelegate!
    
//    @IBAction func btnSelectTimeSlot(_ sender: UIButton) {
//        self.SelectTimeDelegate.selectButton(ButtonIndex: sender.tag)
//
//    }
    
    
    
    
}
