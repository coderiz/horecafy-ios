//
//  ShowPreviewPopupVC.swift
//  horecafy
//
//  Created by aipxperts on 21/08/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import SDWebImage

class ShowPreviewPopupVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var arrImages:[String] = []
    var strVideo: String!
    var showImageVideo = ""
    
   // var player:AVPlayer!
    
    @IBOutlet weak var previewImagesCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var vwPreviewVideo: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pageControl.currentPage = 0
        
        self.hideShow(collVw: true, vw: true, pageCtrl: true)
        
        if self.showImageVideo == "showImages"
        {
            self.hideShow(collVw: false, vw: true, pageCtrl: false)
        }
        else if self.showImageVideo == "showVideo"
        {
            self.hideShow(collVw: true, vw: false, pageCtrl: true)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showImageVideo == "showVideo"
        {
            let videoURL = URL(string: URL_IMAGE_VIDEO_UPLOADS + self.strVideo)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = CGRect(x: 0, y: 0, width: self.vwPreviewVideo.frame.size.width, height: self.vwPreviewVideo.frame.size.height)
            self.vwPreviewVideo.layer.addSublayer(playerLayer)
            player.play()
        }
        else if showImageVideo == "showImages"
        {
            self.pageControl.numberOfPages = self.arrImages.count
        }
    }
    
    func hideShow(collVw: Bool, vw: Bool, pageCtrl: Bool)
    {
        self.previewImagesCollectionView.isHidden = collVw
        self.vwPreviewVideo.isHidden = vw
        self.pageControl.isHidden = pageCtrl
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDismiss(sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewPopupCell", for: indexPath) as! PreviewPopupCell
        
        let url = self.arrImages[indexPath.item]
        let fullURL = URL_IMAGE_VIDEO_UPLOADS + url
        
        cell.ivPreviewImages.sd_setShowActivityIndicatorView(true)
        cell.ivPreviewImages.sd_setIndicatorStyle(.white)
        cell.ivPreviewImages.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "Placeholder_Image"))
        
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        pageControl.currentPage = page
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        pageControl.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
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
