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
local Enemy = class("Enemy",function()
	return cc.Sprite:create()
end)
function Enemy:ctor()
	self.setSpriteFrame("enemy.png")
	self.setPosition(cc.p(size.width/3, size.height/3))
	local hpsprite =cc.Sprite:create("进度条.png")
    local enemyPosX,enemyPosY=self:getPosition()
    hpsprite:setPosition(cc.p(size.width/6, size.height/6+10))
    hpsprite:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(hpsprite,0,11)
end

function Enemy:setbody(ENEMYCODE,ENEMYCONTACT,ENEMYTIGGERCODE)
	local physicsBody = cc.PhysicsBody:createBox(self:getContentSize())
    physicsBody:setCategoryBitmask(ENEMYCODE)
    physicsBody:setContactTestBitmask(ENEMYCONTACT)
    physicsBody:setCollisionBitmask(ENEMYTIGGERCODE) 
    self:addComponent(physicsBody)
end

function Enemy:nowHp( ... )
	local hpsprite =cc.Sprite:create("进度条.png")
    local enemyPosX,enemyPosY=enemysprite:getPosition()
    hpsprite:setPosition(cc.p(size.width/6, size.height/6+10))
    hpsprite:setAnchorPoint(cc.p(0.5,0.5))
    enemysprite:addChild(hpsprite,0,11)
    return hpsprite

end

function Enemy:boom( ... )
    -- body
end
