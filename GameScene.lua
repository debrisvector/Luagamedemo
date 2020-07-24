

local size = cc.Director:getInstance():getWinSize()

local flagStatic=0
local flagX = 0
local flagJump = 0
local STATIC= 1
local MOVERIGHT=2
local MOVELEFT=3
local WALKACTION=4
local JUMPDOWNACTION = 5
local ATTACK=6
local JUMPACTTION = 7
local JUMP = 8
local JUMPTWO = 9
local upGrade=1
local Hero=require("Hero")
local Enemy=require("Enemy")
local GameScene = class("GameScene", function()
    local scene = cc.Scene:createWithPhysics()
    scene:getPhysicsWorld():setGravity(cc.p(0,-50))
    --scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    return scene
end)



function GameScene:ctor()
    self:addChild(self:createLayer())
end


local function CallBack1()
    local buf = string.format("%d段跳",flagJump)
    flagJump=0
    local sprite=layer:getChildByTag(123)
    local animationSprite=sprite:getChildByTag(12)
    animationSprite:stopActionByTag(JUMPTWO)
    animationSprite:stopActionByTag(5)
    animationSprite:stopActionByTag(7)
    if (flagStatic==0)then
        actionStatic=sprite:onStatic()
        actionStatic:retain()
        animationSprite:runAction(actionStatic)
        flagStatic=1
    end
    cclog(buf)

end  

--控键控制

local function onKeyPressed(keyCode, event)
    local buf = string.format("%d 键按下!",keyCode)
    --cclog(buf)
    local sprite =event:getCurrentTarget()
    local animationSprite=sprite:getChildByTag(12)
    --加载动画实例
    if(flagStatic==1)then
    sprite:stopAllActions()
    animationSprite:stopAllActions()
    actionStatic:release()
    flagStatic=0
    end
    if(keyCode ==127)then
        if(flagJump==0)then
            if(flagX==1)then 
                animationSprite:runAction(cc.FlipX:create(false))
                flagX=0
            end   
            walkAction=sprite:onWalk()
            walkAction:setTag(WALKACTION)
            local ac2=animationSprite:runAction(walkAction)
        end
        moveRight =sprite:moveRight()
        moveRight:setTag(MOVERIGHT)
        local ac1=sprite:runAction(moveRight)
    elseif(keyCode ==124)then
            if(flagJump ==0)then
                if(flagX==0)then
                    animationSprite:runAction(cc.FlipX:create(true))
                    flagX=1
                end  
                walkAction=sprite:onWalk()
                walkAction:setTag(WALKACTION)
                local ac4=animationSprite:runAction(walkAction)
            end
            moveLeft =sprite:moveLeft()
            moveLeft:setTag(MOVELEFT)
            local ac3=sprite:runAction(moveLeft)
    elseif(keyCode ==146)then
        if(flagJump ==0)then
            animationSprite:stopActionByTag(WALKACTION)
            flagJump=1
            local ac1=sprite:runAction(cc.JumpBy:create(2,cc.p(0,0),100,1))
            ac1:setTag(JUMP)
            local jumpAction = sprite:onJump()
            jumpAction:setTag(JUMPACTTION)
            local ac2 =animationSprite:runAction(jumpAction)
            local jumpDownAction=sprite:onJumpDown()
            jumpDownAction:setTag(JUMPDOWNACTION)
            local ac3 =animationSprite:runAction(jumpDownAction)
            local acf =cc.CallFunc:create(CallBack1)
            sprite:runAction(cc.Sequence:create(ac1,acf))
        elseif(flagJump==1)then
            flagJump=2
            sprite:stopActionByTag(JUMP)
            animationSprite:stopActionByTag(JUMPDOWNACTION)
            animationSprite:stopActionByTag(JUMPACTTION)
            local jump2 = sprite:runAction(cc.JumpBy:create(2,cc.p(0,0),100,1))
            local onJumpTwo =sprite:onJumpTwo()
            local ac5=animationSprite:runAction(onJumpTwo) 
            ac5:setTag(JUMPTWO)
        end
    elseif(keyCode ==133)then
        if(flagJump ==0)then
            attackAction=sprite:onAttack()
            attackAction:setTag(ATTACK)
            local ac1 =animationSprite:runAction(attackAction)
            if(upGrade==1)then
                bullet=sprite:shootBulletFromFighter(flagX,1)
                bulletUp=sprite:shootBulletFromFighter(flagX,2)
                bulletDown=sprite:shootBulletFromFighter(flagX,3)
                layer:addChild(bullet,0,10)
                layer:addChild(bulletUp,0,11)
                layer:addChild(bulletDown,0,12)
            else
                bullet=sprite:shootBulletFromFighter(flagX,1)
                layer:addChild(bullet,0,10)
            end
        elseif(flagJump==1)then
            animationSprite:stopActionByTag(JUMPDOWNACTION)
            animationSprite:stopActionByTag(JUMPACTTION)
            attackAction=sprite:onAttack()
            local ac1 =animationSprite:runAction(attackAction)
            attackAction:setTag(ATTACK)
            if(upGrade==1)then
                bullet=sprite:shootBulletFromFighter(flagX,1)
                bulletUp=sprite:shootBulletFromFighter(flagX,2)
                bulletDown=sprite:shootBulletFromFighter(flagX,3)
                layer:addChild(bullet,0,10)
                layer:addChild(bulletUp,0,11)
                layer:addChild(bulletDown,0,12)
            else
                bullet=sprite:shootBulletFromFighter(flagX,1)
                layer:addChild(bullet,0,10)
            end
        end
    end
            
end


local function onKeyReleased(keyCode, event)
    local buf = string.format("%d 键抬起!",keyCode)
    local sprite =event:getCurrentTarget()
    local animationSprite=sprite:getChildByTag(12)
    sprite:stopActionByTag(MOVERIGHT)
    sprite:stopActionByTag(MOVELEFT)
    animationSprite:stopActionByTag(WALKACTION)
    animationSprite:stopActionByTag(ATTACK)
    if (flagStatic==0)then
        if(flagJump==0)then
            actionStatic=sprite:onStatic()
            actionStatic:retain()
            animationSprite:runAction(actionStatic)
            flagStatic=1
        end
    end
end

 local function onContactBegin(contact)
        local spriteA = contact:getShapeA():getBody():getNode()
        local spriteB = contact:getShapeB():getBody():getNode()

        if spriteA and  spriteB then
            --spriteA:setColor(cc.c3b(255, 255, 0))
            spriteA:runAction(cc.Hide:create())
            spriteB:setColor(cc.c3b(255, 255, 0))
            spriteB:nowHp()
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
    sprite:setPosition(100,10)
    layer:addChild(sprite,0,123)
    local animationSprite = sprite:getChildByTag(12)
    --sprite:addChild(animationSprite,0,12)

    local enemySprite = Enemy.create()
    enemySprite:setPosition(cc.p(size.width/3, size.height/3))
    layer:addChild(enemySprite,0,1)
    --hpSprite=Enemy:nowHp()
    --layer:addChild(hpSprite)

    --定义世界的边界

    local body = cc.PhysicsBody:createEdgeBox(size,cc.PhysicsMaterial(0.1, 0, 0),0.5)
    local edgeNode = cc.Node:create()
    edgeNode:setPosition(cc.p(size.width/2,size.height/2))
    edgeNode:setPhysicsBody(body)
    layer:addChild(edgeNode)



    --静态动画
    if(flagStatic==0)then    
        actionStatic=sprite:onStatic()
        actionStatic:setTag(STATIC)
        actionStatic:retain()
        animationSprite:runAction(actionStatic)
        flagStatic=1
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

