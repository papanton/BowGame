

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

        print(username)
        print("Joined the room")
        if (AppWarpHelper.sharedInstance.roomId == roomData.roomId && username != AppWarpHelper.sharedInstance.playerName && AppWarpHelper.sharedInstance.isNewRoomCreated){
            AppWarpHelper.sharedInstance.startGameScene!.startMultiplayerGame()

        }
    
    }
    
    
}
