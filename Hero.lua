local HEROCODE=2
local HEROCONTACT=6
local HEROTIGGERCODE=1
local ENEMYCODE = 1
local ENEMYCONTACT=1
local ENEMYTIGGERCODE=1
local BULLETCODE = 1
local BULLETCONTACT=1
local BULLETTIGGERCODE = 1

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
end

function Hero:setbody(HEROCODE,HEROCONTACT,HEROTIGGERCODE)
	local physicsBody = cc.PhysicsBody:createBox(self:getContentSize())
    physicsBody:setCategoryBitmask(HEROCODE)
    physicsBody:setContactTestBitmask(HEROCONTACT)
    physicsBody:setCollisionBitmask(HEROTIGGERCODE) 
    self:addComponent(physicsBody)
	-- body
end

function Hero:shootBulletFromFighter(flagx)
	local  fighterPosX,fighterPosY = self:getPosition()
	local Bullet =Bullet:create(fighterPosX,fighterPosY)
	Bullet:shoot(flagx)
end

function Hero:OnStatic()
    local Onstatic=animationList:create(3,"static",0.2,true)
    return Onstatic
end
   
function Hero:OnWalk()
    local Onwalk=animationList:create(3,"walk",0.2,true)
    return Onwalk
end

function Hero:OnJump()
    local Onjump=animationList:create(5,"jump",0.4,false)
    return Onjump
end
function Hero:OnJumpDown()
    local Onjumpdown=animationList:create(3,"smash-down",0.2,false)
    return Onjumpdown    
end
function Hero:OnAttack()
    local Onattack = animationList:create(4,"charging",0.15,false)
    return Onattack
end
 function Hero:Moveright()
    local move=cc.MoveBy:create(100,cc.p(10000,0))
    return move
end
function Hero:Moveleft()
    local move=cc.MoveBy:create(100,cc.p(-10000,0))
    return move
end

return Hero
