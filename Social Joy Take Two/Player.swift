//
//  Player.swift
//  Social Joy
//
//  Created by Addison G Hodges on 5/1/18.
//  Copyright © 2018 Cohen, Trevor (Genworth). All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class Player {
    var peerID : String
    var playerNumber : String
    var playerAnswer = ""
    
    init(peerID: String, playerNumber: String)
    {
        self.peerID = peerID
        self.playerNumber = playerNumber
    }
}

