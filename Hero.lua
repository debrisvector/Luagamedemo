local HEROCODE=2
local HEROCONTACT=6
local HEROTIGGERCODE=2



local Bullet=require("Bullet")
local animationList= require("animationList")
local size = cc.Director:getInstance():getWinSize()
local Hero = class("Hero",function()
	return cc.Sprite:create()
end)

function Hero:ctor()
	--读取plist
	local spriteFrame =cc.SpriteFrameCache:getInstance()
	spriteFrame:addSpriteFrames("Xenobeta.plist")
	animationsprite =cc.Sprite:createWithSpriteFrameName("static1.png")
	self:addChild(animationsprite,0,12)
    local physicsBody = cc.PhysicsBody:createBox(animationsprite:getContentSize(),cc.PhysicsMaterial(0.1, 0.5, 0.5))
    physicsBody:setCategoryBitmask(HEROCODE)
    physicsBody:setContactTestBitmask(HEROCONTACT)
    physicsBody:setCollisionBitmask(HEROTIGGERCODE) 
    self:setPhysicsBody(physicsBody)
end



function Hero:shootBulletFromFighter(flagx,diraction)
	local  fighterPosX,fighterPosY = self:getPosition()
	local bullet =Bullet:create(fighterPosX,fighterPosY)
	bullet:shoot(flagx,diraction)
    return bullet
end


function Hero:onStatic()
    local onStatic=animationList:ctor(3,"static",0.2,true)
    return onStatic
end
   
function Hero:onWalk()
    local onWalk=animationList:ctor(3,"walk",0.2,true)
    return onWalk
end

function Hero:onJump()
    local onJump=animationList:ctor(5,"jump",0.4,false)
    return onJump
end
function Hero:onJumpDown()
    local onJumpdown=animationList:ctor(3,"smash-down",0.2,false)
    return onJumpdown    
end
function Hero:onAttack()
    local onAttack = animationList:ctor(4,"charging",0.15,false)
    return onAttack
end
 function Hero:moveRight()
    local move=cc.MoveBy:create(100,cc.p(10000,0))
    return move
end
function Hero:moveLeft()
    local move=cc.MoveBy:create(100,cc.p(-10000,0))
    return move
end
function Hero:onJumpTwo()
    local onJumpTwo=animationList:ctor(5,"roll",0.15,true)
    return onJumpTwo  
end

return Hero
