//
//  KVExtensions.swift
//  MergeVideos
//
//  Created by Khoa Vo on 19/10/2021.
//  Copyright © 2021 Khoa Vo. All rights reserved.
//

import UIKit
import AVKit

extension Double {
    func toCMTime() -> CMTime {
        return CMTime(seconds: self, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }
}

extension FileManager {
    func removeItemIfExisted(_ url:URL) -> Void {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            }
            catch {
                print("Failed to delete file")
            }
        }
    }
}

extension AVAssetTrack {
    var fixedPreferredTransform: CGAffineTransform {
        var newT = preferredTransform
        switch [newT.a, newT.b, newT.c, newT.d] {
        case [1, 0, 0, 1]:
            newT.tx = 0
            newT.ty = 0
        case [1, 0, 0, -1]:
            newT.tx = 0
            newT.ty = naturalSize.height
        case [-1, 0, 0, 1]:
            newT.tx = naturalSize.width
            newT.ty = 0
        case [-1, 0, 0, -1]:
            newT.tx = naturalSize.width
            newT.ty = naturalSize.height
        case [0, -1, 1, 0]:
            newT.tx = 0
            newT.ty = naturalSize.width
        case [0, 1, -1, 0]:
            newT.tx = naturalSize.height
            newT.ty = 0
        case [0, 1, 1, 0]:
            newT.tx = 0
            newT.ty = 0
        case [0, -1, -1, 0]:
            newT.tx = naturalSize.height
            newT.ty = naturalSize.width
        default:
            break
        }
        return newT
    }
}
