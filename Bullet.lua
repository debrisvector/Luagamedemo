local HEROCODE=2
local HEROCONTACT=6
local HEROTIGGERCODE=1
local ENEMYCODE = 1
local ENEMYCONTACT=1
local ENEMYTIGGERCODE=1
local BULLETCODE = 1
local BULLETCONTACT=1
local BULLETTIGGERCODE = 1
local size = cc.Director:getInstance():getWinSize()

local Bullet = class("Bullet", function(fighterPosX,fighterPosY)
    return cc.Sprite:create()
end)

function Bullet:ctor(fighterPosX,fighterPosY)
	self.fighterPosX=fighterPosX
	self.fighterPosY=fighterPosY
    bullet=cc.Sprite:create("ball1.png")
    local Bulletbody = cc.PhysicsBody:createBox(bullet:getContentSize(),cc.PhysicsMaterial(0, 0, 0))
    Bulletbody:setCategoryBitmask(BULLETCODE)  --0010
    Bulletbody:setCollisionBitmask(BULLETCONTACT) --0101
    Bulletbody:setContactTestBitmask(BULLETTIGGERCODE);
    bullet:setPhysicsBody(Bulletbody)
    bullet:setPosition(cc.p(fighterPosX+5,fighterPosY))
end

function Bullet:shoot(flagX)
	if(flagx==1)
        then
        Bullet:runAction(cc.MoveBy:create(100,cc.p(-100000,0)))
        return Bullet
    elseif(flagx==0)
        then
        Bullet:runAction(cc.MoveBy:create(100,cc.p(100000,0)))
	end
end

return Bullet