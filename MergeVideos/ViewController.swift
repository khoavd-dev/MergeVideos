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
    
    @IBAction func actionMergeTwoVideos(_ sender: Any) {
        let urlVideo1 = Bundle.main.url(forResource: "movie1", withExtension: "mov")
        let urlVideo2 = Bundle.main.url(forResource: "movie2", withExtension: "mov")
        
        let videoAsset1 = AVAsset(url: urlVideo1!)
        let videoAsset2 = AVAsset(url: urlVideo2!)
        
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        labelProcessing.isHidden = false
        
        KVVideoManager.shared.merge(arrayVideos: [videoAsset1, videoAsset2]) {[weak self] (outputURL, error) in
            guard let aSelf = self else { return }
            
            aSelf.indicatorView.isHidden = true
            aSelf.labelProcessing.isHidden = true

            if let error = error {
                print("Error:\(error.localizedDescription)")
            }
            else {
                if let url = outputURL {
                    aSelf.openPreviewScreen(url)
                }
            }
        }
    }
    
    @IBAction func actionMergeTwoVideosWithAnimation(_ sender: Any) {
        let urlVideo1 = Bundle.main.url(forResource: "movie1", withExtension: "mov")
        let urlVideo2 = Bundle.main.url(forResource: "movie2", withExtension: "mov")
        
        let videoAsset1 = AVAsset(url: urlVideo1!)
        let videoAsset2 = AVAsset(url: urlVideo2!)
        
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        labelProcessing.isHidden = false
        
        KVVideoManager.shared.mergeWithAnimation(arrayVideos: [videoAsset1, videoAsset2]) { [weak self] (outputURL, error) in
            guard let aSelf = self else { return }
            
            aSelf.indicatorView.isHidden = true
            aSelf.labelProcessing.isHidden = true
            
            if let error = error {
                print("Error:\(error.localizedDescription)")
            }
            else {
                if let url = outputURL {
                    aSelf.openPreviewScreen(url)
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
        
        picker.didSelectAssets = {[weak self] (assets: [DKAsset]) in
            guard assets.count > 0 else {return}
            guard let aSelf = self else {return}
            aSelf.preProcess(assets: assets)
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func openPreviewScreen(_ videoURL:URL) -> Void {
        let player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true, completion: {
            player.play()
        })
    }
    
    private func preProcess(assets:[DKAsset]) -> Void {
        var arrayAsset:[VideoData] = []
        
        var index = 0
        assets.forEach { (asset) in
            let videoData = VideoData()
            videoData.index = index
            index += 1
            
            if asset.isVideo {
                videoData.isVideo = true
                
                asset.fetchAVAsset(true, options: nil, completeBlock: { (avAsset, info) in
                    guard let avAsset = avAsset else {return}
                    
                    videoData.asset = avAsset
                    
                    arrayAsset.append(videoData)
                })
            }
            else {
                asset.fetchOriginalImage(true, completeBlock: { (image, info) in
                    guard let image = image else {return}
                    
                    videoData.image = image
                    
                    arrayAsset.append(videoData)
                })
            }
        }
        
        mergeVideosAndImages(arrayData: arrayAsset)
    }
    
    func mergeVideosAndImages(arrayData:[VideoData]) -> Void {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        labelProcessing.isHidden = false
        
        let textData = TextData()
        textData.text = "HELLO WORLD"
        textData.fontSize = 50
        textData.textColor = UIColor.green
        textData.showTime = 3
        textData.endTime = 5
        textData.textFrame = CGRect(x: 0, y: 0, width: 400, height: 300)
        
        KVVideoManager.shared.makeVideoFrom(data: arrayData, textData: [textData], completion: {[weak self] (outputURL, error) in
            guard let aSelf = self else { return }
            
            aSelf.indicatorView.isHidden = true
            aSelf.labelProcessing.isHidden = true
            
            if let error = error {
                print("Error:\(error.localizedDescription)")
            }
            else {
                if let url = outputURL {
                    aSelf.openPreviewScreen(url)
                }
            }
        })
    }
}

