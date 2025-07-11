//
//  MirrorFlyViewUtils.swift
//  mirrorfly_plugin
//
//  Created by Naveen Kumar on 11/07/25.
//

class MirrorFlyViewUtils {
//    
//    private init() {}
//    
//    static let shared: MirrorFlyViewUtils = MirrorFlyViewUtils()
    
    enum ScalingType: String {
        case scaleAspectFit = "SCALE_ASPECT_FIT"
        case scaleAspectBalanced = "SCALE_ASPECT_BALANCED"
        case scaleAspectFill = "SCALE_ASPECT_FILL"
    }

    enum Alignment: String {
        case topLeft, topRight, topCenter
        case bottomLeft, bottomRight, bottomCenter
        case center, centerLeft, centerRight
    }
    
    
}
