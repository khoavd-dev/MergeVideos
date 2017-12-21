# MergeVideos
This is a sample implementation for merging multiple video files and/or image files using AVFoundation, fixed orientation issues. The project is written in Swift 4.

## Features
- Merge multiple video files.
- Merge multiple video files with transition animation.
- Add background music to a video file.
- Merge multiple video files and multiple image files with transition animation.
- Add text with fade in / fade out animation into a video file.

## Requirements
- iOS 9.0+
- Xcode 9.2+
- Swift 4+

## Usage
Drag the file `VideoManager/KVVideoManager.swift` into your project.

Please refer to the sample project `MergeVideos` for more details. (Don't forget to run `pod install` before opening the project).

- Merge multiple video files
```swift
let videoAsset1 = AVAsset(url: urlVideo1!)
let videoAsset2 = AVAsset(url: urlVideo2!)
        
KVVideoManager.shared.merge(arrayVideos: [videoAsset1, videoAsset2]) { (outputURL, error) in
      if let error = error {
           print("Error:\(error.localizedDescription)")
      }
      else {
           if let url = outputURL {
               print("Output video file:\(url)")
           }
     }
}
```
- Merge multiple video files with transition animation
```swift
let videoAsset1 = AVAsset(url: urlVideo1!)
let videoAsset2 = AVAsset(url: urlVideo2!)
        
KVVideoManager.shared.mergeWithAnimation(arrayVideos: [videoAsset1, videoAsset2]) { (outputURL, error) in
      if let error = error {
           print("Error:\(error.localizedDescription)")
      }
      else {
           if let url = outputURL {
               print("Output video file:\(url)")
           }
     }
}
```
- Add background music to a video file
```swift
let videoAsset = AVAsset(url: urlVideo!)
let musicAsset = AVAsset(url: urlMusic!)
        
KVVideoManager.shared.merge(video:videoAsset, withBackgroundMusic:musicAsset) { (outputURL, error) in
      if let error = error {
           print("Error:\(error.localizedDescription)")
      }
      else {
           if let url = outputURL {
               print("Output video file:\(url)")
           }
     }
}
```
- Merge multiple video files and multiple image files and text with transition animation
```swift
let videoData = VideoData()
videoData.isVideo = true
videoData.asset = AVAsset(url: urlVideo!)

let imageData = VideoData()
imageData.isVideo = false
imageData.image = UIImage(named: "sample-image")
        
let textData = TextData()
textData.text = "HELLO WORLD"
textData.fontSize = 50
textData.textColor = UIColor.green
textData.showTime = 3 // Second
textData.endTime = 5 // Second
textData.textFrame = CGRect(x: 0, y: 0, width: 400, height: 300)
        
KVVideoManager.shared.makeVideoFrom(data: [videoData, imageData], textData: [textData]) { (outputURL, error) in
     if let error = error {
           print("Error:\(error.localizedDescription)")
      }
      else {
           if let url = outputURL {
               print("Output video file:\(url)")
           }
     }      
}
```
## Note
This is a sample implementation to demonstrate the functions in AVFoundation with just some simple animations, but you got the idea ! 

You would be able to add more complicated transition animation, text showing animation by using Core Animation !!!

