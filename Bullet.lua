local BULLETCODE = 1
local BULLETCONTACT=1
local BULLETTIGGERCODE = 1
local size = cc.Director:getInstance():getWinSize()

local Bullet = class("Bullet",  function()
    return cc.Sprite:create("ball1.png")
end)

function Bullet:ctor(fighterPosX,fighterPosY)  
	self.fighterPosX=fighterPosX
	self.fighterPosY=fighterPosY
    local bulletBody = cc.PhysicsBody:createBox(self:getContentSize(),cc.PhysicsMaterial(0, 0, 0))
    bulletBody:setCategoryBitmask(BULLETCODE)  --0010
    bulletBody:setCollisionBitmask(BULLETCONTACT) --0101
    bulletBody:setContactTestBitmask(BULLETTIGGERCODE);
    self:setPhysicsBody(bulletBody)
    self:setPosition(cc.p(fighterPosX+5,fighterPosY))
end

function Bullet:shoot(flagX,diraction)
	if(flagX==1)then
        if(diraction==1)then
            self:runAction(cc.MoveBy:create(100,cc.p(-100000,0)))
        elseif(diraction==2)then
            self:runAction(cc.MoveBy:create(100,cc.p(-100000,100000)))
        elseif(diraction==3)then
            self:runAction(cc.MoveBy:create(100,cc.p(-100000,-100000)))
        end
    elseif(flagX==0)then
        if(diraction==1)then
        self:runAction(cc.MoveBy:create(100,cc.p(100000,0)))
        elseif(diraction==2)then
            self:runAction(cc.MoveBy:create(100,cc.p(100000,100000)))
        elseif(diraction==3)then
            self:runAction(cc.MoveBy:create(100,cc.p(100000,-100000)))
        end
	end
end



return Bullet