local animationList = class("animationList")

function animationList:ctor(numberOfFrames,animationName,animationTime,repeatBool)
	self.numberOfFrames=numberOfFrames
	self.animationName=animationName
	self.animationTime=animationTime
	self.repeatBool=repeatBool
    local spriteFrame =cc.SpriteFrameCache:getInstance()
    spriteFrame:addSpriteFrames("Xenobeta.plist")
	--///////////////动画开始//////////////////////
    local animation = cc.Animation:create()
    for i=1, numberOfFrames do
        local frameName = string.format(animationName.."%d.png",i)
        --cclog("frameName = %s",frameName)
        local spriteFrame2 = spriteFrame:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame2)
    end

    animation:setDelayPerUnit(animationTime)           --设置两个帧播放时间
    animation:setRestoreOriginalFrame(false)    --动画执行后还原初始状态

    local action = cc.Animate:create(animation)
    if(repeatBool)then
        local Repeatacttion=cc.RepeatForever:create(action)
        return Repeatacttion
    else
        return action
    end
end

return animationList