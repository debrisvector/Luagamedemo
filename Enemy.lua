local ENEMYCODE = 1
local ENEMYCONTACT=1
local ENEMYTIGGERCODE=1
local ENEMYHP = 100
local BULLETDAMEIGE=20

local size = cc.Director:getInstance():getWinSize()
local Enemy = class("Enemy",function()
	return cc.Sprite:create("enemy.png")
end)
function Enemy:ctor()
    local hpSize=self:getContentSize()
	local hpSprite =cc.Sprite:create("进度条.png",cc.rect(0,0,hpSize["width"],10))
    local enemyPosX,enemyPosY=self:getPosition()
    hpSprite:setPosition(enemyPosX,enemyPosY+enemyPosY/2)
    hpSprite:setAnchorPoint(cc.p(0,0))
    self:addChild(hpSprite,0,11)
    local physicsBody = cc.PhysicsBody:createBox(self:getContentSize(),cc.PhysicsMaterial(0.1, 0.5, 0.5))
    physicsBody:setCategoryBitmask(ENEMYCODE)
    physicsBody:setContactTestBitmask(ENEMYCONTACT)
    physicsBody:setCollisionBitmask(ENEMYTIGGERCODE) 
    self:setPhysicsBody(physicsBody)
end



function Enemy:nowHp( ... )
    local hpSprite=self:getChildByTag(11)
    ENEMYHP=ENEMYHP-BULLETDAMEIGE
    if(ENEMYHP>0)then
        hpSprite:setScaleX(ENEMYHP/100)
    else
        hpSprite:runAction(cc.Hide:create())
        self:boom()
        upGrade=1
    end

end

function Enemy:boom()
    self:stopAllActions()
    local function delete()
        self:removeFromParent(true)
    end
    performWithDelay(self:getParent(), delete, 0.1)
end
    
return Enemy
