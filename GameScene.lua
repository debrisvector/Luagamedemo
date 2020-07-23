

local size = cc.Director:getInstance():getWinSize()

local flagstatic=0
local flagx = 0
local flagjump = 0
local STATIC= 1
local MOVERIGHT=2
local MOVELEFT=3
local WALKACTION=4
local JUMPDOWNACTION = 5
local ATTACK=6
local JUMPACTTION = 7
local Hero=require("Hero")
local Enemy=require("Enemy")
local GameScene = class("GameScene", function()
    local scene = cc.Scene:createWithPhysics()
    scene:getPhysicsWorld():setGravity(cc.p(0,-50))
    scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    return scene
end)



function GameScene:ctor()
    self:addChild(self:createLayer())
end


local function CallBack1()
    local buf = string.format("%d段跳",flagjump)
    flagjump=0
    local sprite=layer:getChildByTag(123)
    local animationsprite=sprite:getChildByTag(12)
    animationsprite:stopActionByTag(5)
    animationsprite:stopActionByTag(7)
    cclog(buf)

end  

--控键控制

local function onKeyPressed(keyCode, event)
    local buf = string.format("%d 键按下!",keyCode)
    --cclog(buf)
    local sprite =event:getCurrentTarget()
    local animationsprite=sprite:getChildByTag(12)
    --加载动画实例
    if(flagstatic==1)then
    sprite:stopAllActions()
    animationsprite:stopAllActions()
    ActionStatic:release()
    flagstatic=0
    end
    if(keyCode ==127)then
        if(flagjump==0)then
            if(flagx==1)then 
                animationsprite:runAction(cc.FlipX:create(false))
                flagx=0
            end   
            Walkaction=sprite:Onwalk()
            Walkaction:setTag(WALKACTION)
            local ac2=animationsprite:runAction(Walkaction)
        end
        moveright =sprite:Moveright()
        moveright:setTag(MOVERIGHT)
        local ac1=sprite:runAction(moveright)
    elseif(keyCode ==124)then
            if(flagjump ==0)then
                if(flagx==0)then
                    animationsprite:runAction(cc.FlipX:create(true))
                    flagx=1
                end  
                Walkaction=sprite:Onwalk()
                Walkaction:setTag(WALKACTION)
                local ac4=animationsprite:runAction(Walkaction)
            end
            moveleft =sprite:Moveleft()
            moveleft:setTag(MOVELEFT)
            local ac3=sprite:runAction(moveleft)
    elseif(keyCode ==146)then
        if(flagjump ==0)then
            animationsprite:stopActionByTag(WALKACTION)
            flagjump=1
            local ac1=sprite:runAction(cc.JumpBy:create(2,cc.p(0,0),100,1))
            jumpaction = sprite:Onjump()
            jumpaction:setTag(JUMPACTTION)
            local ac2 =animationsprite:runAction(jumpaction)
            jumpdownaction=sprite:Onjumpdown()
            jumpdownaction:setTag(JUMPDOWNACTION)
            local ac3 =animationsprite:runAction(jumpdownaction)
            local acf =cc.CallFunc:create(CallBack1)
            sprite:runAction(cc.Sequence:create(ac1,acf)) 
        end
    elseif(keyCode ==133)then
        if(flagjump ==0)then
            attackaction=sprite:Onattack()
            attackaction:setTag(ATTACK)
            local ac1 =animationsprite:runAction(attackaction)
            Bullet=shootBulletFromFighter(sprite,flagx)
            layer:addChild(Bullet,0,10)
        else
            animationsprite:stopActionByTag(JUMPDOWNACTION)
            animationsprite:stopActionByTag(JUMPACTTION)
            attackaction=sprite:Onattack()
            local ac1 =animationsprite:runAction(attackaction)
            attackaction:setTag(ATTACK)
            Bullet=shootBulletFromFighter(sprite,flagx)
            layer:addChild(Bullet,0,10)
        end
    end
            
end


local function onKeyReleased(keyCode, event)
    local buf = string.format("%d 键抬起!",keyCode)
    local sprite =event:getCurrentTarget()
    local animationsprite=sprite:getChildByTag(12)
    sprite:stopActionByTag(MOVERIGHT)
    sprite:stopActionByTag(MOVELEFT)
    animationsprite:stopActionByTag(WALKACTION)
    animationsprite:stopActionByTag(ATTACK)
    if (flagstatic==0)then
        if(flagjump==0)then
            ActionStatic=Onstatic()
            ActionStatic:retain()
            animationsprite:runAction(ActionStatic)
            flagstatic=1
        end
    end
end

 local function onContactBegin(contact)
        local spriteA = contact:getShapeA():getBody():getNode()
        local spriteB = contact:getShapeB():getBody():getNode()

        if spriteA and spriteB then 
            spriteA:setColor(cc.c3b(255, 0, 0))
            spriteB:setColor(cc.c3b(255, 0, 0))
        end
        cclog("danbang")
    end

local function onContactPreSolve(contact)
        cclog("onContactPreSolve")
        return true
    end

local function onContactPostSolve(contact)
    cclog("onContactPostSolve")
end

local function onContactSeparate(contact)
      local spriteA = contact:getShapeA():getBody():getNode()
        local spriteB = contact:getShapeB():getBody():getNode()

        if spriteA  and spriteB then
            spriteA:setColor(cc.c3b(255, 255, 255))
            spriteB:setColor(cc.c3b(255, 255, 255))
        end
        cclog("onContactSeparate")
    end
-- create layer
function GameScene:createLayer()

    layer = cc.Layer:create()
    local director=cc.Director:getInstance()
    

    local sprite = Hero.create()
    sprite:setPosition(cc.p(size.width/2, size.height/2))
    layer:addChild(sprite,0,123)
    sprite:addChild(animationsprite,0,12)

    local enemysprite = Enemy.create()
    layer:addChild(enemysprite,0,1)
    hpsprite=Enemy:nowHp()
    layer:addChild(hpsprite)

    --定义世界的边界

    local body = cc.PhysicsBody:createEdgeBox(size,cc.PhysicsMaterial(0.1, 0, 0),0.5)
    local edgeNode = cc.Node:create()
    edgeNode:setPosition(cc.p(size.width/2,size.height/2))
    edgeNode:setPhysicsBody(body)
    layer:addChild(edgeNode)



    --静态动画
    if(flagstatic==0)then    
        ActionStatic=sprite.Onstatic()
        ActionStatic:setTag(STATIC)
        ActionStatic:retain()
        animationsprite:runAction(ActionStatic)
        flagstatic=1
    end

    -- 创建一个键盘监听器
    local listener = cc.EventListenerKeyboard:create()
    local contactListener = cc.EventListenerPhysicsContact:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    contactListener:registerScriptHandler(onContactPreSolve, cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
    contactListener:registerScriptHandler(onContactPostSolve, cc.Handler.EVENT_PHYSICS_CONTACT_POSTSOLVE)
    contactListener:registerScriptHandler(onContactSeparate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPARATE)
    local eventDispatcher = self:getEventDispatcher()
    -- 添加监听器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, sprite)
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, layer)

    ---帧动画函数

    

    return layer

end

return GameScene

