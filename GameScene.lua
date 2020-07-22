

local size = cc.Director:getInstance():getWinSize()

local flagstatic=0
local i1=0
local flagx = 0
local flagjump = 0

local GameScene = class("GameScene", function()
    local scene = cc.Scene:createWithPhysics()
    scene:getPhysicsWorld():setGravity(cc.p(0,-50))
    --scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    return scene
end)



function GameScene:ctor()
    self:addChild(self:createLayer())
end

--读取plist
local spriteFrame =cc.SpriteFrameCache:getInstance()
spriteFrame:addSpriteFrames("Xenobeta.plist")

--动画类
local function Moveright()
    local move=cc.MoveBy:create(100,cc.p(10000,0))
    return move
end
local function Moveleft()
    local move=cc.MoveBy:create(100,cc.p(-10000,0))
    return move
end
local function animationlist(NUMBEROFFRAMES,ANIMATIONNAME,ANIMATIONTIME,BOOLEAN)
            --///////////////动画开始//////////////////////
            local animation = cc.Animation:create()
            for i=1, NUMBEROFFRAMES do

                local frameName = string.format(ANIMATIONNAME.."%d.png",i)
                --cclog("frameName = %s",frameName)
                local spriteFrame2 = spriteFrame:getSpriteFrame(frameName)
                animation:addSpriteFrame(spriteFrame2)
            end

            animation:setDelayPerUnit(ANIMATIONTIME)           --设置两个帧播放时间
            animation:setRestoreOriginalFrame(false)    --动画执行后还原初始状态

            local action = cc.Animate:create(animation)
            if(BOOLEAN)then
                local Repeatacttion=cc.RepeatForever:create(action)
                return Repeatacttion
            else
                return action
            end
            --//////////////////动画结束///////////////////
    end
local function Onstatic()
    local Onstatic=animationlist(3,"static",0.2,true)
    return Onstatic
end
   
local function Onwalk()
    local Onwalk=animationlist(3,"walk",0.2,true)
    return Onwalk
end

local function Onjump()
    local Onjump=animationlist(5,"jump",0.4,false)
    return Onjump
end
local function Onjumpdown()
    local Onjumpdown=animationlist(3,"smash-down",0.2,false)
    return Onjumpdown    
end
local function Onattack()
    local Onattack = animationlist(4,"charging",0.15,false)
    return Onattack
end

local  function shootBulletFromFighter(sprite,flagx)
    local  fighterPosX,fighterPosY = sprite:getPosition()

    Bullet=cc.Sprite:create("ball1.png")
    local Bulletbody = cc.PhysicsBody:createBox(Bullet:getContentSize(),cc.PhysicsMaterial(0.5, 0.5, 0.5))
    Bulletbody:setCategoryBitmask(0x01)  --0010
    Bulletbody:setCollisionBitmask(0X01) --0101
    Bulletbody:setContactTestBitmask(0X01);
    Bullet:setPhysicsBody(Bulletbody)
    Bullet:setPosition(cc.p(fighterPosX+5,fighterPosY))
    if(flagx==1)
        then
        Bullet:runAction(cc.MoveBy:create(100,cc.p(-100000,0)))
        return Bullet
    elseif(flagx==0)
        then
        Bullet:runAction(cc.MoveBy:create(100,cc.p(100000,0)))
        return Bullet
    end
    -- body
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
            Walkaction=Onwalk()
            Walkaction:setTag(4)
            local ac2=animationsprite:runAction(Walkaction)
        end
        moveright =Moveright()
        moveright:setTag(2)
        local ac1=sprite:runAction(moveright)
    elseif(keyCode ==124)then
            if(flagjump ==0)then
                if(flagx==0)then
                    animationsprite:runAction(cc.FlipX:create(true))
                    flagx=1
                end  
                Walkaction=Onwalk()
                Walkaction:setTag(4)
                local ac4=animationsprite:runAction(Walkaction)
            end
            moveleft =Moveleft()
            moveleft:setTag(3)
            local ac3=sprite:runAction(moveleft)
    elseif(keyCode ==146)then
        if(flagjump ==0)then
            animationsprite:stopActionByTag(4)
            flagjump=1
            local ac1=sprite:runAction(cc.JumpBy:create(2,cc.p(0,0),100,1))
            jumpaction = Onjump()
            jumpaction:setTag(7)
            local ac2 =animationsprite:runAction(jumpaction)
            jumpdownaction=Onjumpdown()
            jumpdownaction:setTag(5)
            local ac3 =animationsprite:runAction(jumpdownaction)
            local acf =cc.CallFunc:create(CallBack1)
            sprite:runAction(cc.Sequence:create(ac1,acf)) 
        end
    elseif(keyCode ==133)then
        if(flagjump ==0)then
            attackaction=Onattack()
            attackaction:setTag(6)
            local ac1 =animationsprite:runAction(attackaction)
            Bullet=shootBulletFromFighter(sprite,flagx)
            layer:addChild(Bullet,0,10)
        else
            animationsprite:stopActionByTag(5)
            animationsprite:stopActionByTag(7)
            attackaction=Onattack()
            local ac1 =animationsprite:runAction(attackaction)
            attackaction:setTag(6)
            Bullet=shootBulletFromFighter(sprite,flagx)
            layer:addChild(Bullet,0,10)
        end
    end
            
end


local function onKeyReleased(keyCode, event)
    local buf = string.format("%d 键抬起!",keyCode)
    local sprite =event:getCurrentTarget()
    local animationsprite=sprite:getChildByTag(12)
    sprite:stopActionByTag(2)
    sprite:stopActionByTag(3)
    animationsprite:stopActionByTag(4)
    animationsprite:stopActionByTag(6)
    if (flagstatic==0)then
        if(flagjump==0)then
            ActionStatic=Onstatic()
            ActionStatic:retain()
            animationsprite:runAction(ActionStatic)
            flagstatic=1
            i1=i1+1
            cclog(i1)
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
    

    local sprite = cc.Sprite:create()
    local animationsprite =cc.Sprite:createWithSpriteFrameName("static1.png")
    sprite:setPosition(cc.p(size.width/2, size.height/2))
    local Herobody = cc.PhysicsBody:createBox(animationsprite:getContentSize(),cc.PhysicsMaterial(0.1, 0, 0.5))
    Herobody:setCategoryBitmask(0x02)  --0001
    Herobody:setCollisionBitmask(0x06) --0110
    sprite:setPhysicsBody(Herobody)
    layer:addChild(sprite,0,123)
    sprite:addChild(animationsprite,0,12)


    local enemysprite=cc.Sprite:create("enemy.png")
    local enemybody = cc.PhysicsBody:createBox(enemysprite:getContentSize(),cc.PhysicsMaterial(0.5, 0.5, 0.5))
    enemysprite:setPosition(cc.p(size.width/3, size.height/3))
    enemybody:setCategoryBitmask(0x01) --0100
    enemybody:setCollisionBitmask(0X01) --0011
    enemybody:setContactTestBitmask(0X01);
    enemysprite:setPhysicsBody(enemybody)
    layer:addChild(enemysprite,0,1)

    local hpsprite =cc.Sprite:create("进度条.png")
    local enemyPosX,enemyPosY=enemysprite:getPosition()
    hpsprite:setPosition(cc.p(enemyPosX,enemyPosY+10))
    enemysprite:addChild(hpsprite,0,11)






    --定义世界的边界


    local body = cc.PhysicsBody:createEdgeBox(size,cc.PhysicsMaterial(0.1, 0, 0),0.5)
    local edgeNode = cc.Node:create()
    edgeNode:setPosition(cc.p(size.width/2,size.height/2))
    edgeNode:setPhysicsBody(body)
    layer:addChild(edgeNode)



    --静态动画
    if(flagstatic==0)then    
        ActionStatic=Onstatic()
        ActionStatic:setTag(1)
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

