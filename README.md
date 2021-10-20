# MergeVideos
This is a sample implementation for merging multiple videos and/or images using AVFoundation, fixed orientation issues.

## Features
- Merge videos.
- Merge videos with transition animation.
- Add background music to a video.
- Merge videos and images with transition animation.
- Add text with fade in / fade out animation into a video.

## Requirements
- iOS 13.0+
- Xcode 13.0+
- Swift 5+

## Updates
### 20/10/2021
- Update source code to run on Xccode 13 and Swift 5.
- Refactor code.
- Fix issue: merging videos shows black screen sometimes. (update `videoCompositionInstructionForTrack` function)

## Usage
Drag the files in `VideoManager` folder into your project.

Please refer to the sample project `MergeVideos` for more details. (Don't forget to run `pod install` before opening the project).

- Merge videos
```swift
let videoAsset1 = AVAsset(url: urlVideo1)
let videoAsset2 = AVAsset(url: urlVideo2)
        
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
- Merge videos with transition animation
```swift
let videoAsset1 = AVAsset(url: urlVideo1)
let videoAsset2 = AVAsset(url: urlVideo2)
        
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
- Add background music to a video
```swift
let videoAsset = AVAsset(url: urlVideo)
let musicAsset = AVAsset(url: urlMusic)
        
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
- Merge videos and images and text with transition animation
```swift
let videoData = VideoData()
videoData.isVideo = true
videoData.asset = AVAsset(url: urlVideo)

let imageData = VideoData()
imageData.isVideo = false
imageData.image = UIImage(named: "sample-image")
        
let textData = TextData(text: "HELLO WORLD",
                        fontSize: 50,
                        textColor: UIColor.green,
                        showTime: 3,
                        endTime: 5,
                        textFrame: CGRect(x: 0, y: 0, width: 400, height: 300))
        
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

