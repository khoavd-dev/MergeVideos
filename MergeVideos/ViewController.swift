//
//  ViewController.swift
//  MergeVideos
//
//  Created by Khoa Vo on 12/20/17.
//  Copyright © 2017 Khoa Vo. All rights reserved.
//

import UIKit
import AVKit
import DKImagePickerController

class ViewController: UIViewController {
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var labelProcessing: UILabel!
    @IBOutlet weak var buttonMergeVideosImages: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.isHidden = true
        labelProcessing.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showProcessing(isShow: Bool) {
        if isShow {
            indicatorView.isHidden = false
            indicatorView.startAnimating()
            labelProcessing.isHidden = false
        } else {
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            labelProcessing.isHidden = true
        }
    }
    
    @IBAction func actionMergeTwoVideos(_ sender: Any) {
        guard let portraitURL = Bundle.main.url(forResource: "portrait", withExtension: "MOV"),
              let landscapeURL = Bundle.main.url(forResource: "landscape", withExtension: "MOV")
        else { return }
        
        
        
        let portraitAsset = AVAsset(url: portraitURL)
        let landscapeAsset = AVAsset(url: landscapeURL)
        
        showProcessing(isShow: true)
        
        DispatchQueue.global().async {
            KVVideoManager.shared.merge(arrayVideos: [portraitAsset, landscapeAsset]) {[weak self] (outputURL, error) in
                guard let `self` = self else { return }
                
                DispatchQueue.main.async {
                    self.showProcessing(isShow: false)

                    if let error = error {
                        print("Error:\(error.localizedDescription)")
                    }
                    else if let url = outputURL {
                        self.openPreviewScreen(url)
                    }
                }
            }
        }
    }
    
    @IBAction func actionMergeTwoVideosWithAnimation(_ sender: Any) {
        guard let videoURL1 = Bundle.main.url(forResource: "movie1", withExtension: "mov"),
              let videoURL2 = Bundle.main.url(forResource: "movie2", withExtension: "mov")
        else { return }
        
        let videoAsset1 = AVAsset(url: videoURL1)
        let videoAsset2 = AVAsset(url: videoURL2)
        
        showProcessing(isShow: true)
        
        DispatchQueue.global().async {
            KVVideoManager.shared.mergeWithAnimation(arrayVideos: [videoAsset1, videoAsset2]) { [weak self] (outputURL, error) in
                guard let `self` = self else { return }
                
                DispatchQueue.main.async {
                    self.showProcessing(isShow: false)
                    
                    if let error = error {
                        print("Error:\(error.localizedDescription)")
                    }
                    else if let url = outputURL {
                        self.openPreviewScreen(url)
                    }
                }
            }
        }
    }
    
    @IBAction func actionButtonAddMusic(_ sender: Any) {
        guard let videoURL = Bundle.main.url(forResource: "portrait", withExtension: "MOV"),
              let musicURL = Bundle.main.url(forResource: "sample", withExtension: "mp3")
        else { return }
        
        let videoAsset = AVAsset(url: videoURL)
        let musicAsset = AVAsset(url: musicURL)
        
        showProcessing(isShow: true)
        
        DispatchQueue.global().async {
            KVVideoManager.shared.merge(video: videoAsset, withBackgroundMusic: musicAsset) {[weak self] (outputURL, error) in
                guard let `self` = self else { return }
                
                DispatchQueue.main.async {
                    self.showProcessing(isShow: false)
                    
                    if let error = error {
                        print("Error:\(error.localizedDescription)")
                    }
                    else if let url = outputURL {
                        self.openPreviewScreen(url)
                    }
                }
            }
        }
    }
    
    
    @IBAction func actionButtonMergeVideosAndImages(_ sender: Any) {
        let picker = DKImagePickerController()
        picker.assetType = .allAssets
        picker.showsEmptyAlbums = false
        picker.showsCancelButton = true
        picker.allowsLandscape = false
        picker.maxSelectableCount = 6
        picker.modalPresentationStyle = .fullScreen
        
        picker.didSelectAssets = {[weak self] (assets: [DKAsset]) in
            guard let `self` = self, assets.count > 0 else {return}
            self.preprocess(assets: assets)
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    private func openPreviewScreen(_ videoURL:URL) -> Void {
        let player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.modalPresentationStyle = .fullScreen
        
        present(playerController, animated: true, completion: {
            player.play()
        })
    }
    
    private func preprocess(assets: [DKAsset]) {
        var arrayAsset:[VideoData] = []
        
        var index = 0
        let group = DispatchGroup()
        
        assets.forEach { (asset) in
            var videoData = VideoData()
            videoData.index = index
            index += 1
            
            if asset.type == .video {
                videoData.isVideo = true
                
                group.enter()
                asset.fetchAVAsset { (avAsset, info) in
                    guard let avAsset = avAsset else {
                        group.leave()
                        return
                    }
                    
                    videoData.asset = avAsset
                    arrayAsset.append(videoData)
                    group.leave()
                }
            }
            else {
                group.enter()
                asset.fetchOriginalImage { (image, info) in
                    guard let image = image else {
                        group.leave()
                        return
                    }
                    
                    videoData.image = image
                    arrayAsset.append(videoData)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.mergeVideosAndImages(arrayData: arrayAsset)
        }
    }
    
    private func mergeVideosAndImages(arrayData: [VideoData]) {
        showProcessing(isShow: true)
        
        let textData = TextData(text: "HELLO WORLD",
                                fontSize: 50,
                                textColor: UIColor.green,
                                showTime: 3,
                                endTime: 5,
                                textFrame: CGRect(x: 0, y: 0, width: 400, height: 300))
        
        DispatchQueue.global().async {
            KVVideoManager.shared.makeVideoFrom(data: arrayData, textData: [textData], completion: {[weak self] (outputURL, error) in
                guard let `self` = self else { return }
                
                DispatchQueue.main.async {
                    self.showProcessing(isShow: false)
                    
                    if let error = error {
                        print("Error:\(error.localizedDescription)")
                    } else if let url = outputURL {
                        self.openPreviewScreen(url)
                    }
                }
            })
        }
    }
}

