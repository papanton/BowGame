

import UIKit

class NotificationListener: NSObject,NotifyListener
{
    func onUpdatePeersReceived(updateEvent:UpdateEvent)
    {
        print("onUpdatePeersReceived")
        AppWarpHelper.sharedInstance.receivedEnemyStatus(updateEvent.update)
    }
    func onUserLeftRoom(roomData: RoomData!, username: String!)
    {
        
    }
    
    func onUserResumed(userName: String!, withLocation locId: String!, isLobby: Bool)
    {
        
    }
    
    func onUserPaused(userName: String!, withLocation locId: String!, isLobby: Bool)
    {
        
    }
    
    func onUserJoinedRoom(roomData: RoomData!, username: String!){
        //AppWarpHelper.sharedInstance.startGameScene!.startMultiplayerGame()

        print(username)
        print("Joined the room")
    
    }
    
}
