//
//  FlyChatObserver.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 16/11/23.
//

import Foundation
import MirrorFlySDK

public protocol FlyChatUserDelegate {
    func userProfileDidChange(for jid: String, profileDetails: MirrorFlySDK.ProfileDetails)
}
