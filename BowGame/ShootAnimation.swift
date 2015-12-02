// ---------------------------------------
// Sprite definitions for 'ShootAnimation'
// Generated with TexturePacker 3.9.4
//
// http://www.codeandweb.com/texturepacker
// ---------------------------------------

import SpriteKit


class ShootAnimation {
    static var instance : ShootAnimation?
    static func getInstance() ->ShootAnimation
    {
        if instance == nil{
            instance = ShootAnimation()
        }
        return instance!
    }
    private init(){}
    // sprite names
    let SHOOT_01 = "Shoot/01"
    let SHOOT_02 = "Shoot/02"
    let SHOOT_03 = "Shoot/03"
    let SHOOT_04 = "Shoot/04"
    let SHOOT_05 = "Shoot/05"
    let SHOOT_06 = "Shoot/06"
    let SHOOT_07 = "Shoot/07"
    let SHOOT_08 = "Shoot/08"
    let SHOOT_09 = "Shoot/09"
    let SHOOT_10 = "Shoot/10"
    let SHOOT_11 = "Shoot/11"
    let SHOOT_12 = "Shoot/12"
    let SHOOT_13 = "Shoot/13"
    let SHOOT_14 = "Shoot/14"
    let SHOOT_15 = "Shoot/15"
    let SHOOT_16 = "Shoot/16"
    let SHOOT_17 = "Shoot/17"
    let SHOOT_18 = "Shoot/18"


    // load texture atlas
    let textureAtlas = SKTextureAtlas(named: "ShootAnimation")


    // individual texture objects
    func Shoot_01() -> SKTexture { return textureAtlas.textureNamed(SHOOT_01) }
    func Shoot_02() -> SKTexture { return textureAtlas.textureNamed(SHOOT_02) }
    func Shoot_03() -> SKTexture { return textureAtlas.textureNamed(SHOOT_03) }
    func Shoot_04() -> SKTexture { return textureAtlas.textureNamed(SHOOT_04) }
    func Shoot_05() -> SKTexture { return textureAtlas.textureNamed(SHOOT_05) }
    func Shoot_06() -> SKTexture { return textureAtlas.textureNamed(SHOOT_06) }
    func Shoot_07() -> SKTexture { return textureAtlas.textureNamed(SHOOT_07) }
    func Shoot_08() -> SKTexture { return textureAtlas.textureNamed(SHOOT_08) }
    func Shoot_09() -> SKTexture { return textureAtlas.textureNamed(SHOOT_09) }
    func Shoot_10() -> SKTexture { return textureAtlas.textureNamed(SHOOT_10) }
    func Shoot_11() -> SKTexture { return textureAtlas.textureNamed(SHOOT_11) }
    func Shoot_12() -> SKTexture { return textureAtlas.textureNamed(SHOOT_12) }
    func Shoot_13() -> SKTexture { return textureAtlas.textureNamed(SHOOT_13) }
    func Shoot_14() -> SKTexture { return textureAtlas.textureNamed(SHOOT_14) }
    func Shoot_15() -> SKTexture { return textureAtlas.textureNamed(SHOOT_15) }
    func Shoot_16() -> SKTexture { return textureAtlas.textureNamed(SHOOT_16) }
    func Shoot_17() -> SKTexture { return textureAtlas.textureNamed(SHOOT_17) }
    func Shoot_18() -> SKTexture { return textureAtlas.textureNamed(SHOOT_18) }

    func getTextureByDiff (diff: CGFloat) -> SKTexture {
        let section:CGFloat = diff / 4.5 + 8
        let intValue = Int(section)
        let number:String
        
        if (intValue <= 0) {
            number = "01"
        } else if (section < 10) {
            number = "0" + String(intValue)
        } else if (section > 17) {
            number = String(17)
        } else {
            number = String(intValue)
        }
//        print("\nnumber:")
//        print(number)
        
        return textureAtlas.textureNamed("Shoot/" + number)
    }
    
    
    // texture arrays for animations
    func Shoot() -> [SKTexture] {
        return [
//            Shoot_01(),
//            Shoot_02(),
//            Shoot_03(),
//            Shoot_04(),
//            Shoot_05(),
//            Shoot_06(),
//            Shoot_07(),
//            Shoot_08(),
//            Shoot_09(),
//            Shoot_10(),
//            Shoot_11(),
//            Shoot_12(),
//            Shoot_13(),
//            Shoot_14(),
//            Shoot_15(),
//            Shoot_16(),
            Shoot_17(),
            Shoot_18(),
            Shoot_17(),
            Shoot_16(),
            Shoot_15(),
            Shoot_14(),
            Shoot_13(),
            Shoot_12(),
            Shoot_11(),
            Shoot_10(),
            Shoot_09(),
            Shoot_08(),
            Shoot_07(),
            Shoot_06(),
            Shoot_05(),
            Shoot_04(),
            Shoot_01()
        ]
    }


}
