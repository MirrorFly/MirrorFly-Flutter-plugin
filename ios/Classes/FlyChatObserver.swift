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
    func chatManagerStatus(status: ConnectionStatus)
}


public enum ConnectionStatus {
    case connected
    case disconnected
    case reconnecting
    case notAuthorized
    case connectionfailed(error: String)
}


extension Notification.Name {
    static let connectionStatusChanged = Notification.Name("connectionStatusChanged")
}
