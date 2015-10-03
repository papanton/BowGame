import UIKit
import SpriteKit
import Darwin

class MultiPlayerActions: SKScene, EasyGameCenterDelegate {
    
    var current_game : SKScene?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        addButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
}


    
    func addButtons(){
        let findPlayerButton = SKSpriteNode(imageNamed: StartButtonImage)
        findPlayerButton.position = CGPointMake(size.width/2,size.height*0.80 )
        findPlayerButton.name = "findPlayer"
        
        let disconnectButton = SKSpriteNode(imageNamed: ResumeButtonImage )
        disconnectButton.position = CGPointMake(size.width/2,size.height*0.60 )
        disconnectButton.name = "disconnectMatch"
        
        addChild(findPlayerButton)
        addChild(disconnectButton)
   
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == "findPlayer"){
            EasyGameCenter.findMatchWithMinPlayers(2, maxPlayers: 2)

        }else if(touchedNode.name == "disconnectMatch"){
            
            EasyGameCenter.disconnectMatch()

            }
            
        }
            
}