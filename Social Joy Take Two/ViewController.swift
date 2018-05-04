//
//  mainMenuViewController.swift
//  Social Joy
//
//  Created by Cohen, Trevor (Genworth) on 5/1/18.
//  Copyright © 2018 Cohen, Trevor (Genworth). All rights reserved.
//

import UIKit
import MultipeerConnectivity

//Could add multiplayer class but for now...

//var thePlayers = [MCPeerID]()
var thePlayers = [Player]()
var testingValue = 0


class mainMenuViewController: UIViewController, MCBrowserViewControllerDelegate,MCSessionDelegate {
    
    @IBOutlet weak var startQuizButton: UIButton!
    
    var browser: MCBrowserViewController!
    var session: MCSession!
    var peerID: MCPeerID!
    var assistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var aQuiz = Quiz()
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "quiz", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "quiz", discoveryInfo: nil, session: session)
        
        assistant.start()
        session.delegate = self
        browser.delegate = self
        
        thePlayers.append(Player(peerID: self.peerID.displayName, playerNumber: "1"))
        
        //Set up single player & mmultiplayer games
        //self.singlePlayerGame = SinglePlayerGame(currentPlayer: Player(peerID: self.peerID))
        
    }
    
    //**********************************************************
    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }
    //**********************************************************
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func connectButtonClick(_ sender: Any) {
       present(browser, animated: true, completion: nil)

    }
    
    
//    @IBAction func startQuiz(_ sender: Any) {
//
//        //If it's single player we can just start game but if its multiplayer...
//
//        //Send peer daata & preform segue
//        do {
//            let peerData = NSKeyedArchiver.archivedData(withRootObject: "StartingTheGame")
//            try session.send(peerData, toPeers: session.connectedPeers, with: .unreliable)
//        }
//        catch let err {
//            print("Data could not be sent :(")
//        }
//
//        performSegue(withIdentifier: "toTheGame", sender: self)
//
//        //let data = NSKeyedArchiver.archivedDat(withRootObject: "START")
//        // session.send(data, toPeers: session.connectedPeers, with: .unreliable)
//    }
    
    
    @IBAction func startQuiz(_ sender: Any) {
        
                //If it's single player we can just start game but if its multiplayer...
        
                //Send peer daata & preform segue
                do {
                    let peerData = NSKeyedArchiver.archivedData(withRootObject: "StartingTheGame")
                    try session.send(peerData, toPeers: session.connectedPeers, with: .unreliable)
                }
                catch let err {
                    print("Data could not be sent :(")
                }
        
                performSegue(withIdentifier: "toTheGame", sender: self)
        
                //let data = NSKeyedArchiver.archivedDat(withRootObject: "START")
                // session.send(data, toPeers: session.connectedPeers, with: .unreliable)
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        DispatchQueue.main.async(execute: {
            
            if let recievedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
                if recievedString == "StartingTheGame"
                {
                    self.performSegue(withIdentifier: "toTheGame", sender: self)
                }
            }
        })
    }
    
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            //let playerID = peerID
            //thePlayers.append(playerID)
            
            if thePlayers.count == 0
            {
                thePlayers.append(Player(peerID: peerID.displayName, playerNumber: "1"))
            }
            else if thePlayers.count == 1
            {
                thePlayers.append(Player(peerID: peerID.displayName, playerNumber: "2"))
            }
            else if thePlayers.count == 2
            {
                thePlayers.append(Player(peerID: peerID.displayName, playerNumber: "3"))
            }
            else if thePlayers.count == 3
            {
                thePlayers.append(Player(peerID: peerID.displayName, playerNumber:"4"))
            }
//
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
        
    }
    
    
}
